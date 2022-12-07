import RealmSwift

class RealmLocationDetail: RealmSwift.Object {
    @Persisted(primaryKey: true) var primaryId: String
    @Persisted var dimension: String

    @Persisted var residents: List<RealmCharacterSummary>
    @Persisted(originProperty: "detail") var summary: LinkingObjects<RealmLocationSummary>

    static private let schemaId = "location-details-"

    static func primaryId(id: String) -> String {
        return "\(schemaId)\(id)"
    }

    convenience init(detail: LocationDetail) {
        self.init()
        self.primaryId = Self.primaryId(id: detail.id)
        self.dimension = detail.dimension
    }

    func delete(realm: Realm) {
        var oldResidents: [RealmCharacterSummary] = []
        residents.forEach {
            oldResidents.append($0)
        }
        residents.removeAll()
        oldResidents.forEach { $0.delete(realm: realm) }

        realm.delete(self)
    }

    func toDomain() -> LocationDetail {
        let summary = summary.first!.toLocationSummary()!
        return LocationDetail.Builder()
            .set(id: summary.id)
            .set(name: summary.name)
            .set(type: summary.type)
            .set(dimension: dimension)
            .set(residents: residents.map { $0.toDomain() })
            .build()
    }
}
