import RxSwift

class EpisodesRepositoryImpl: EpisodesRepository {
    let remoteDataSource: EpisodesRemoteDataSource
    let localDataSource: EpisodesLocalDataSource

    init(remoteDataSource: EpisodesRemoteDataSource, localDataSource: EpisodesLocalDataSource) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func fetch(filter: EpisodeFilter) async -> Result<PaginatedResponse<EpisodeSummary>, Error> {
        let localEpisodes = await localDataSource.getEpisodes(filter: filter)
        if let localEpisodes = localEpisodes {
            return .success(PaginatedResponse(items: localEpisodes, hasNext: true))
        }

        return await refetch(filter: filter)
    }

    func fetchNextPage(
        filter: EpisodeFilter,
        listSize: UInt32
    ) async -> Result<PaginatedResponse<EpisodeSummary>, Error> {
        if listSize % remoteDataSource.pageSize > 0 { return .success(PaginatedResponse(items: [], hasNext: false)) }
        let page = UInt32(listSize / remoteDataSource.pageSize) + 1

        let episodes = await remoteDataSource.getEpisodes(page: page, filter: filter)
        guard let episodes = episodes.unwrap() else { return .failure(episodes.failure()!)}

        await localDataSource.insertEpisodes(episodes: episodes.items, filter: filter)

        return .success(episodes)
    }

    func refetch(filter: EpisodeFilter) async -> Result<PaginatedResponse<EpisodeSummary>, Error> {
        let episodes = await remoteDataSource.getEpisodes(page: 1, filter: filter)
        guard let episodes = episodes.unwrap() else { return .failure(episodes.failure()!)}

        await localDataSource.setEpisodes(episodes: episodes.items, filter: filter)

        return .success(episodes)
    }
}
