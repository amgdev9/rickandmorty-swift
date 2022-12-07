protocol EpisodesLocalDataSource {
    func insertEpisodes(episodes: [EpisodeSummary], filter: EpisodeFilter) async
    func setEpisodes(episodes: [EpisodeSummary], filter: EpisodeFilter) async
    func getEpisodes(filter: EpisodeFilter) async -> [EpisodeSummary]?
}
