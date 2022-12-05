class EpisodeSummary {
    let id: String
    let seasonId: String
    let name: String
    let date: Date

    init(id: String, seasonId: String, name: String, date: Date) {
        self.id = id
        self.seasonId = seasonId
        self.name = name
        self.date = date
    }
}

extension EpisodeSummary {
    class Mother {
        static func build(id: String) -> EpisodeSummary {
            return EpisodeSummary(id: id, seasonId: "S01E01", name: "Pilot", date: Date())
        }
    }
}
