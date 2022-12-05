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
        return await withCheckedContinuation { continuation in
            realmQueue.async {
                do {
                    let realm = try self.realmFactory.build()

                    let realmFilter = RealmCharacterFilter(filter: filter)
                    let list = realm.objects(RealmCharacterList.self)
                        .where { $0.filter.primaryId.equals(realmFilter.primaryId) }

                    guard let list = list.first else { return continuation.resume(returning: .none) }

                    var domainCharacters: [CharacterSummary] = []
                    list.characters.forEach {
                        domainCharacters.append($0.toDomain())
                    }

                    return continuation.resume(returning: domainCharacters)
                } catch {
                    return continuation.resume(returning: .none)
                }
            }
        }
    }

    func insertCharacters(characters: [CharacterSummary], filter: CharacterFilter) async {
        return await withCheckedContinuation { continuation in
            realmQueue.async {
                defer {
                    continuation.resume(returning: ())
                }

                do {
                    let realm = try self.realmFactory.build()

                    let filterId = RealmCharacterFilter(filter: filter).primaryId
                    let realmFilter = realm.objects(RealmCharacterFilter.self)
                        .where { $0.primaryId.equals(filterId) }
                    guard let realmFilter = realmFilter.first else { return continuation.resume(returning: ()) }

                    let list = realm.objects(RealmCharacterList.self)
                        .where { $0.filter.primaryId.equals(realmFilter.primaryId) }

                    if let list = list.first {
                        try realm.write {
                            let numDiscardedCharacters = max(
                                list.characters.count + characters.count - self.maxCharactersPerList,
                                0
                            )
                            let realmCharacters = characters
                                .dropLast(numDiscardedCharacters)
                                .map { RealmCharacterSummary(character: $0) }

                            realmCharacters.forEach {
                                realm.add($0, update: .modified)
                            }

                            list.characters.append(objectsIn: realmCharacters)
                        }
                    } else {
                        try realm.write {
                            self.createNewList(with: characters, realm: realm, filter: realmFilter)
                        }
                    }
                } catch {}
            }
        }
    }

    private func createNewList(with characters: [CharacterSummary], realm: Realm, filter: RealmCharacterFilter) {
        let list = RealmCharacterList(filter: filter)

        let numDiscardedCharacters = max(characters.count - self.maxCharactersPerList, 0)
        let realmCharacters = characters.dropLast(numDiscardedCharacters).map { RealmCharacterSummary(character: $0) }

        realmCharacters.forEach {
            realm.add($0, update: .modified)
        }
        list.characters.append(objectsIn: realmCharacters)

        realm.add(list)
    }

    func setCharacters(characters: [CharacterSummary], filter: CharacterFilter) async {
        return await withCheckedContinuation { continuation in
            realmQueue.async {
                defer {
                    continuation.resume(returning: ())
                }

                do {
                    let realm = try self.realmFactory.build()

                    let filterId = RealmCharacterFilter(filter: filter).primaryId
                    let realmFilter = realm.objects(RealmCharacterFilter.self)
                        .where { $0.primaryId.equals(filterId) }
                    guard let realmFilter = realmFilter.first else { return continuation.resume(returning: ()) }

                    let list = realm.objects(RealmCharacterList.self)
                        .where { $0.filter.primaryId.equals(realmFilter.primaryId) }
                        .first

                    try realm.write {
                        if let list = list {
                            list.delete(realm: realm)
                        }

                        self.createNewList(with: characters, realm: realm, filter: realmFilter)
                    }
                } catch {}
            }
        }
    }
}
