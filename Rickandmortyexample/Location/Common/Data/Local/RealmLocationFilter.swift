import RealmSwift

class RealmLocationFilter: RealmSwift.Object {
    @Persisted(primaryKey: true) var primaryId: String
    @Persisted var name: String
    @Persisted var type: String
    @Persisted var dimension: String
    @Persisted var createdAt: Date

    @Persisted(originProperty: "filter") var list: LinkingObjects<RealmLocationList>

    static private let schemaId = "location-filter-"

    convenience init(filter: LocationFilter) {
        self.init()
        name = filter.name
        type = filter.type
        dimension = filter.dimension
        primaryId = "\(Self.schemaId)\(name)-\(type)-\(dimension)"
        createdAt = Date()
    }

    func delete(realm: Realm) {
        list.forEach { $0.delete(realm: realm) }
        realm.delete(self)
    }

    func toDomain() -> LocationFilter {
        return LocationFilter(
            name: name,
            type: type,
            dimension: dimension
        )
    }
}
