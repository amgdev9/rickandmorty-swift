import RealmSwift

class RealmEpisodeDetails: RealmSwift.Object {
    @Persisted(primaryKey: true) var primaryId: String

    @Persisted var characters: List<RealmCharacterSummary>
    @Persisted(originProperty: "detail") var summary: LinkingObjects<RealmEpisodeSummary>

    static private let schemaId = "episode-details-"

    static func primaryId(id: String) -> String {
        return "\(schemaId)\(id)"
    }

    convenience init(detail: EpisodeDetail) {
        self.init()
        self.primaryId = Self.primaryId(id: detail.id)
    }

    func delete(realm: Realm) {
        var oldCharacters: [RealmCharacterSummary] = []
        characters.forEach {
            oldCharacters.append($0)
        }
        characters.removeAll()
        oldCharacters.forEach { $0.delete(realm: realm) }

        realm.delete(self)
    }

    func toDomain() -> EpisodeDetail {
        let summary = summary.first!.toDomain()
        return EpisodeDetail.Builder()
            .set(id: summary.id)
            .set(seasonID: summary.seasonId)
            .set(name: summary.name)
            .set(date: summary.date)
            .set(characters: characters.map { $0.toDomain() })
            .build()
    }
}
