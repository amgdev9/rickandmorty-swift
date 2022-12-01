import RealmSwift

class RealmCharactersDataSource: CharactersLocalDataSource {
    let realmFactory: RealmFactory
    let realmQueue: DispatchQueue

    private let maxCharactersPerList = 60

    init(realmFactory: RealmFactory, realmQueue: DispatchQueue) {
        self.realmFactory = realmFactory
        self.realmQueue = realmQueue
    }

    func getCharacters(filter: CharacterFilter) async -> [CharacterSummary]? {
        print("GETCHARACTERS")
        return await withCheckedContinuation { continuation in
            realmQueue.async {
                do {
                    let realm = try self.realmFactory.build()

                    let realmFilter = RealmCharacterFilter(filter: filter)
                    let list = realm.objects(RealmCharacterList.self)
                        .where { $0.filter.id.equals(realmFilter.id) }

                    var domainCharacters: [CharacterSummary] = []
                    list.first?.characters.forEach {
                        domainCharacters.append($0.toDomain())
                    }

                    print("GETCHARACTERS \(domainCharacters.count)")

                    return continuation.resume(returning: domainCharacters)
                } catch {}
            }
        }
    }

    func insertCharacters(characters: [CharacterSummary], filter: CharacterFilter) async {
        print("INSERTCHARACTERS")
        return await withCheckedContinuation { continuation in
            realmQueue.async {
                do {
                    let realm = try self.realmFactory.build()

                    let realmFilter = RealmCharacterFilter(filter: filter)

                    let list = realm.objects(RealmCharacterList.self)
                        .where { $0.filter.id.equals(realmFilter.id) }

                    if let list = list.first {
                        if list.characters.count + characters.count > self.maxCharactersPerList { return continuation.resume(returning: ()) }

                        try realm.write {
                            let realmCharacters = characters.map { RealmCharacterSummary(character: $0) }
                            list.characters.append(objectsIn: realmCharacters)
                        }
                    } else {
                        let list = RealmCharacterList(filter: realmFilter)
                        if characters.count > self.maxCharactersPerList { return continuation.resume(returning: ()) }

                        try realm.write {
                            let realmCharacters = characters.map { RealmCharacterSummary(character: $0) }
                            list.characters.append(objectsIn: realmCharacters)

                            realm.add(list)
                        }
                    }

                    return continuation.resume(returning: ())
                } catch {}
            }
        }
    }

    func setCharacters(characters: [CharacterSummary], filter: CharacterFilter) async {
        print("SETCHARACTERS")
        return await withCheckedContinuation { continuation in
            realmQueue.async {
                do {
                    if characters.count > self.maxCharactersPerList { return continuation.resume(returning: ()) }

                    let realm = try self.realmFactory.build()

                    let realmFilter = RealmCharacterFilter(filter: filter)

                    let list = realm.objects(RealmCharacterList.self)
                        .where { $0.filter.id.equals(realmFilter.id) }
                        .first

                    try realm.write {
                        if let list = list {
                            list.delete(realm: realm)
                        }

                        let list = RealmCharacterList(filter: realmFilter)

                        let realmCharacters = characters.map { RealmCharacterSummary(character: $0) }
                        list.characters.append(objectsIn: realmCharacters)

                        realm.add(list)
                    }

                    return continuation.resume(returning: ())
                } catch {}
            }
        }
    }
}
