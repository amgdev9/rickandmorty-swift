import RealmSwift

class RealmLocationSummary: RealmSwift.Object {
    @Persisted(primaryKey: true) var primaryId: String
    @Persisted var name: String
    @Persisted var type: String?
    @Persisted(originProperty: "origin") var originInCharacter: LinkingObjects<RealmCharacterDetails>
    @Persisted(originProperty: "location") var locationInCharacter: LinkingObjects<RealmCharacterDetails>

    static private let schemaId = "location-summary-"

    static func primaryId(id: String) -> String {
        return "\(schemaId)\(id)"
    }

    convenience init(characterLocation: CharacterLocation) {
        self.init()
        self.primaryId = "\(Self.schemaId)\(characterLocation.id)"
        self.name = characterLocation.name
        self.type = .none
    }

    convenience init(locationSummary: LocationSummary) {
        self.init()
        self.primaryId = "\(Self.schemaId)\(locationSummary.id)"
        self.name = locationSummary.name
        self.type = locationSummary.type
    }

    func delete(realm: Realm) {
        if !originInCharacter.isEmpty { return }
        if !locationInCharacter.isEmpty { return }

        realm.delete(self)
    }

    func toCharacterLocation() -> CharacterLocation {
        return CharacterLocation(id: String(primaryId.dropFirst(Self.schemaId.count)), name: name)
    }

    func toLocationSummary() -> LocationSummary? {
        guard let type = type else { return .none }
        return LocationSummary.Builder()
            .set(id: String(primaryId.dropFirst(Self.schemaId.count)))
            .set(name: name)
            .set(type: type)
            .build()
    }
}
