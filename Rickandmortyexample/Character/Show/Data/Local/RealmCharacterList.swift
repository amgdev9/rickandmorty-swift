import RealmSwift

class RealmCharacterList: RealmSwift.Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var characters: List<RealmCharacterSummary>
    @Persisted var filter: RealmCharacterFilter?

    convenience init(filter: RealmCharacterFilter) {
        self.init()
        self.filter = filter
        id = "character-list-\(filter.id)"
    }

    func delete(realm: Realm) {
        filter = .none

        let oldCharacters = characters.map { RealmCharacterSummary(value: $0) }

        characters.removeAll()
        realm.delete(self)

        oldCharacters.forEach {
            $0.delete(realm: realm)
        }
    }
}
