import RealmSwift

class RealmEpisodeSummary: RealmSwift.Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var seasonId: String
    @Persisted var name: String
    @Persisted var date: Date
    @Persisted(originProperty: "episodes") var episodeInCharacter: LinkingObjects<RealmCharacterDetails>

    convenience init(episodeSummary: EpisodeSummary) {
        self.init()
        self.id = episodeSummary.id
        self.seasonId = episodeSummary.seasonId
        self.name = episodeSummary.name
        self.date = episodeSummary.date
    }

    func delete(realm: Realm) {
        if !episodeInCharacter.isEmpty { return }

        realm.delete(self)
    }

    func toDomain() -> EpisodeSummary {
        return EpisodeSummary(id: id, seasonId: seasonId, name: name, date: date)
    }
}
