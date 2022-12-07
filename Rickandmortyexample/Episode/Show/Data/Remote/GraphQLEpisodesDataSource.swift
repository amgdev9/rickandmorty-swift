import Apollo

class GraphQLEpisodesDataSource: EpisodesRemoteDataSource {
    var pageSize: UInt32 = 20

    let apolloClient: ApolloClient

    init(apolloClient: ApolloClient) {
        self.apolloClient = apolloClient
    }

    func getEpisodes(page: UInt32, filter: EpisodeFilter) async -> Result<PaginatedResponse<EpisodeSummary>, Error> {
        let result = await apolloClient.fetchAsync(
            query: EpisodesQuery(page: Int(page), filter: FilterEpisode.from(filter: filter))
        )
        guard let result = result.unwrap() else {
            return .failure(Error(message: result.failure()!.localizedDescription))
        }

        guard let episodes = result.data?.episodes?.results else {
            return .failure(Error(message: String(localized: "error/unknown")))
        }

        guard let info = result.data?.episodes?.info else {
            return .failure(Error(message: String(localized: "error/unknown")))
        }

        let domainEpisodes = episodes
            .compactMap { $0 }
            .map { $0.fragments.episodeSummaryFragment.toDomain() }

        return .success(PaginatedResponse(items: domainEpisodes, hasNext: info.next != nil))
    }
}

extension FilterEpisode {
    static func from(filter: EpisodeFilter) -> Self {
        return FilterEpisode(
            name: .from(filter.name),
            episode: .from(filter.episode)
        )
    }
}
