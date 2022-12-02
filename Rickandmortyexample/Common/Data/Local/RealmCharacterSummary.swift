import RealmSwift

class RealmCharacterSummary: RealmSwift.Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var imageURL: String
    @Persisted var name: String
    @Persisted var status: Int8

    @Persisted(originProperty: "characters") var lists: LinkingObjects<RealmCharacterList>
    @Persisted var uncachedList: RealmCharacterList?
    @Persisted var detail: RealmCharacterDetails?

    convenience init(character: CharacterSummary) {
        self.init()
        id = character.id
        imageURL = character.imageURL
        name = character.name
        status = mapFromDomain(status: character.status)
    }

    func delete(realm: Realm) {
        if !lists.isEmpty { return }
        if uncachedList != nil { return }

        detail = .none
        detail?.delete(realm: realm)
        realm.delete(self)
    }

    private func mapFromDomain(status: Character.Status) -> Int8 {
        switch status {
        case .alive: return 0
        case .dead: return 1
        case .unknown: return 2
        }
    }

    private func mapStatusToDomain(status: Int8) -> Character.Status {
        switch status {
        case 0: return .alive
        case 1: return .dead
        default: return .unknown
        }
    }

    func toDomain() -> CharacterSummary {
        return CharacterSummary.Builder()
            .set(id: id)
            .set(name: name)
            .set(imageURL: imageURL)
            .set(status: mapStatusToDomain(status: status))
            .build()
    }
}
