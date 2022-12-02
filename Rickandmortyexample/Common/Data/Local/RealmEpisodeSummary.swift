import RealmSwift

class RealmEpisodeSummary: RealmSwift.Object {
    @Persisted(primaryKey: true) var primaryId: String
    @Persisted var seasonId: String
    @Persisted var name: String
    @Persisted var date: Date
    @Persisted(originProperty: "episodes") var episodeInCharacter: LinkingObjects<RealmCharacterDetails>

    static private let schemaId = "episode-summary-"

    static func primaryId(id: String) -> String {
        return "\(schemaId)\(id)"
    }

    convenience init(episodeSummary: EpisodeSummary) {
        self.init()
        self.primaryId = "\(Self.schemaId)\(episodeSummary.id)"
        self.seasonId = episodeSummary.seasonId
        self.name = episodeSummary.name
        self.date = episodeSummary.date
    }

    func delete(realm: Realm) {
        if !episodeInCharacter.isEmpty { return }

        realm.delete(self)
    }

    func toDomain() -> EpisodeSummary {
        return EpisodeSummary(id: String(primaryId.dropFirst(Self.schemaId.count)), seasonId: seasonId, name: name, date: date)
    }
}
