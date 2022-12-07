protocol EpisodesRemoteDataSource {
    var pageSize: UInt32 { get }
    func getEpisodes(page: UInt32, filter: EpisodeFilter) async -> Result<PaginatedResponse<EpisodeSummary>, Error>
}
