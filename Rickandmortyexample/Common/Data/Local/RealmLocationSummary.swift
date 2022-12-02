import RealmSwift

class RealmLocationSummary: RealmSwift.Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var type: String?
    @Persisted(originProperty: "origin") var originInCharacter: LinkingObjects<RealmCharacterDetails>
    @Persisted(originProperty: "location") var locationInCharacter: LinkingObjects<RealmCharacterDetails>

    convenience init(characterLocation: CharacterLocation) {
        self.init()
        self.id = characterLocation.id
        self.name = characterLocation.name
        self.type = .none
    }

    convenience init(locationSummary: LocationSummary) {
        self.init()
        self.id = locationSummary.id
        self.name = locationSummary.name
        self.type = locationSummary.type
    }

    func delete(realm: Realm) {
        if !originInCharacter.isEmpty { return }
        if !locationInCharacter.isEmpty { return }

        realm.delete(self)
    }

    func toCharacterLocation() -> CharacterLocation {
        return CharacterLocation(id: id, name: name)
    }

    func toLocationSummary() -> LocationSummary? {
        guard let type = type else { return .none }
        return LocationSummary.Builder()
            .set(id: id)
            .set(name: name)
            .set(type: type)
            .build()
    }
}
