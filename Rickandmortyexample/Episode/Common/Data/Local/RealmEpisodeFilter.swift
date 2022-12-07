import RealmSwift

class RealmEpisodeFilter: RealmSwift.Object {
    @Persisted(primaryKey: true) var primaryId: String
    @Persisted var name: String
    @Persisted var episode: String
    @Persisted var createdAt: Date

    @Persisted(originProperty: "filter") var list: LinkingObjects<RealmEpisodeList>

    static private let schemaId = "episode-filter-"

    convenience init(filter: EpisodeFilter) {
        self.init()
        name = filter.name
        episode = filter.episode
        primaryId = "\(Self.schemaId)\(name)-\(episode)"
        createdAt = Date()
    }

    func delete(realm: Realm) {
        list.forEach { $0.delete(realm: realm) }
        realm.delete(self)
    }

    func toDomain() -> EpisodeFilter {
        return EpisodeFilter(
            name: name,
            episode: episode
        )
    }
}
