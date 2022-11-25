class EpisodeSeason {
    let id: UInt16
    let episodes: [EpisodeSummary]

    init(id: UInt16, episodes: [EpisodeSummary]) {
        self.id = id
        self.episodes = episodes
    }
}
