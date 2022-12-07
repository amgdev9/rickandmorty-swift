import RealmSwift

class RealmEpisodeSummary: RealmSwift.Object {
    @Persisted(primaryKey: true) var primaryId: String
    @Persisted var seasonId: String
    @Persisted var name: String
    @Persisted var date: Date

    @Persisted(originProperty: "episodes") var episodeInCharacter: LinkingObjects<RealmCharacterDetails>
    @Persisted(originProperty: "episodes") var lists: LinkingObjects<RealmEpisodeList>
    @Persisted(originProperty: "uncachedEpisodes") var uncachedLists: LinkingObjects<RealmEpisodeList>
    @Persisted var detail: RealmEpisodeDetails?

    static private let schemaId = "episode-summary-"

    static func primaryId(id: String) -> String {
        return "\(schemaId)\(id)"
    }

    convenience init(episodeSummary: EpisodeSummary) {
        self.init()
        self.primaryId = Self.primaryId(id: episodeSummary.id)
        self.seasonId = episodeSummary.seasonId
        self.name = episodeSummary.name
        self.date = episodeSummary.date
    }

    func delete(realm: Realm) {
        if !lists.isEmpty { return }
        if !uncachedLists.isEmpty { return }
        if !episodeInCharacter.isEmpty { return }

        let oldDetail = detail
        realm.delete(self)
        oldDetail?.delete(realm: realm)
    }

    func toDomain() -> EpisodeSummary {
        return EpisodeSummary(
            id: String(primaryId.dropFirst(Self.schemaId.count)),
            seasonId: seasonId,
            name: name,
            date: date
        )
    }
}
