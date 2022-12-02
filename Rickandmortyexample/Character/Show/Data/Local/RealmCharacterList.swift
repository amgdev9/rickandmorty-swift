import RealmSwift

class RealmCharacterList: RealmSwift.Object {
    @Persisted(primaryKey: true) var primaryId: String

    @Persisted var characters: List<RealmCharacterSummary>
    @Persisted var filter: RealmCharacterFilter?

    static private let schemaId = "character-list-"

    static func primaryId(id: String) -> String {
        return "\(schemaId)\(id)"
    }

    convenience init(filter: RealmCharacterFilter) {
        self.init()
        self.filter = filter
        primaryId = "\(Self.schemaId)\(filter.primaryId)"
    }

    func delete(realm: Realm) {
        filter = .none

        var oldCharacters: [RealmCharacterSummary] = []

        characters.forEach {
            oldCharacters.append($0)
        }

        characters.removeAll()
        realm.delete(self)

        oldCharacters.forEach {
            $0.delete(realm: realm)
        }
    }
}
