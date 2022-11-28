protocol EpisodesRemoteDataSource {
    var pageSize: UInt { get }
    func getEpisodes(page: UInt, filter: EpisodeFilter) async -> Result<PaginatedResponse<EpisodeSeason>, Error>
}
