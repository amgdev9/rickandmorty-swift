import Apollo

class GraphQLEpisodesDataSource: EpisodesRemoteDataSource {
    var pageSize: UInt = 20

    let apolloClient: ApolloClient

    init(apolloClient: ApolloClient) {
        self.apolloClient = apolloClient
    }

    func getEpisodes(page: UInt, filter: EpisodeFilter) async -> Result<PaginatedResponse<EpisodeSeason>, Error> {
        var cancellable: Cancellable? = .none
        return await withTaskCancellationHandler { [cancellable] in
            cancellable?.cancel()
        } operation: {
            return await withCheckedContinuation { continuation in
                cancellable = apolloClient.fetch(
                    query: EpisodesQuery(page: Int(page), filter: FilterEpisode.from(filter: filter))
                ) { result in
                    guard let result = result.unwrap() else {
                        return continuation.resume(returning: .failure(Error(message: result.failure()!.localizedDescription)))
                    }

                    guard let episodes = result.data?.episodes?.results else {
                        return continuation.resume(returning: .failure(Error(message: String(localized: "error/unknown"))))
                    }

                    guard let pages = result.data?.episodes?.info?.pages else {
                        return continuation.resume(returning: .failure(Error(message: String(localized: "error/unknown"))))
                    }

                    let domainEpisodes = episodes
                        .compactMap { $0 }
                        .map { $0.fragments.episodeSummaryFragment.toDomain() }

                    let seasons: [EpisodeSeason] = Dictionary(grouping: domainEpisodes, by: {
                        UInt16($0.seasonId.slice(from: "S", to: "E")!)!
                    }).map { key, episodes in
                        return EpisodeSeason(id: key, episodes: episodes)
                    }

                    continuation.resume(returning:
                            .success(PaginatedResponse(numPages: UInt32(pages), items: seasons))
                    )
                }
            }
        }
    }
}

extension FilterEpisode {
    // TODO This is used in multiple places
    static func mapString(_ value: String) -> GraphQLNullable<String> {
        if value.isEmpty { return .none }
        return .some(value)
    }

    static func from(filter: EpisodeFilter) -> Self {
        return FilterEpisode(
            name: mapString(filter.name),
            episode: mapString(filter.episode)
        )
    }
}
