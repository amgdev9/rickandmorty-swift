import RxSwift

protocol EpisodesRepository {
    func fetch(filter: EpisodeFilter) async -> Result<PaginatedResponse<EpisodeSummary>, Error>
    func fetchNextPage(
        filter: EpisodeFilter,
        listSize: UInt32
    ) async -> Result<PaginatedResponse<EpisodeSummary>, Error>
    func refetch(filter: EpisodeFilter) async -> Result<PaginatedResponse<EpisodeSummary>, Error>
}
