import RealmSwift

class RealmLocationSummary: RealmSwift.Object {
    @Persisted(primaryKey: true) var primaryId: String
    @Persisted var name: String
    @Persisted var type: String?

    @Persisted(originProperty: "locations") var lists: LinkingObjects<RealmLocationList>
    @Persisted(originProperty: "uncachedLocations") var uncachedLists: LinkingObjects<RealmLocationList>
    @Persisted(originProperty: "origin") var originInCharacter: LinkingObjects<RealmCharacterDetails>
    @Persisted(originProperty: "location") var locationInCharacter: LinkingObjects<RealmCharacterDetails>
    @Persisted var detail: RealmLocationDetail?

    static private let schemaId = "location-summary-"

    static func primaryId(id: String) -> String {
        return "\(schemaId)\(id)"
    }

    convenience init(characterLocation: CharacterLocation, type: String?) {
        self.init()
        self.primaryId = Self.primaryId(id: characterLocation.id)
        self.name = characterLocation.name
        self.type = type
    }

    convenience init(locationSummary: LocationSummary) {
        self.init()
        self.primaryId = Self.primaryId(id: locationSummary.id)
        self.name = locationSummary.name
        self.type = locationSummary.type
    }

    func delete(realm: Realm) {
        if !lists.isEmpty { return }
        if !uncachedLists.isEmpty { return }
        if !originInCharacter.isEmpty { return }
        if !locationInCharacter.isEmpty { return }

        let oldDetail = detail
        realm.delete(self)
        oldDetail?.delete(realm: realm)
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
