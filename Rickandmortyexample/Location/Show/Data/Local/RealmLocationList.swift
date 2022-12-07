import RealmSwift

class RealmLocationList: RealmSwift.Object {
    @Persisted(primaryKey: true) var primaryId: String

    @Persisted var locations: List<RealmLocationSummary>
    @Persisted var filter: RealmLocationFilter?
    @Persisted var uncachedLocations: List<RealmLocationSummary>

    static private let schemaId = "location-list-"

    static func primaryId(id: String) -> String {
        return "\(schemaId)\(id)"
    }

    convenience init(filter: RealmLocationFilter) {
        self.init()
        self.filter = filter
        primaryId = Self.primaryId(id: filter.primaryId)
    }

    func delete(realm: Realm) {
        var oldLocations: [RealmLocationSummary] = []
        var oldUncachedLocations: [RealmLocationSummary] = []

        locations.forEach {
            oldLocations.append($0)
        }

        uncachedLocations.forEach {
            oldUncachedLocations.append($0)
        }

        locations.removeAll()
        uncachedLocations.removeAll()
        realm.delete(self)

        oldLocations.forEach {
            $0.delete(realm: realm)
        }

        oldUncachedLocations.forEach {
            $0.delete(realm: realm)
        }
    }
}
