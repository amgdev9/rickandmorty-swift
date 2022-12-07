import RealmSwift

class RealmEpisodeList: RealmSwift.Object {
    @Persisted(primaryKey: true) var primaryId: String

    @Persisted var episodes: List<RealmEpisodeSummary>
    @Persisted var filter: RealmEpisodeFilter?
    @Persisted var uncachedEpisodes: List<RealmEpisodeSummary>

    static private let schemaId = "episode-list-"

    static func primaryId(id: String) -> String {
        return "\(schemaId)\(id)"
    }

    convenience init(filter: RealmEpisodeFilter) {
        self.init()
        self.filter = filter
        primaryId = Self.primaryId(id: filter.primaryId)
    }

    func delete(realm: Realm) {
        var oldEpisodes: [RealmEpisodeSummary] = []
        var oldUncachedEpisodes: [RealmEpisodeSummary] = []

        episodes.forEach {
            oldEpisodes.append($0)
        }

        uncachedEpisodes.forEach {
            oldUncachedEpisodes.append($0)
        }

        episodes.removeAll()
        uncachedEpisodes.removeAll()
        realm.delete(self)

        oldEpisodes.forEach {
            $0.delete(realm: realm)
        }

        oldUncachedEpisodes.forEach {
            $0.delete(realm: realm)
        }
    }
}
