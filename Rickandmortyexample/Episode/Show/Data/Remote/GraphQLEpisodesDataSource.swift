import Apollo

class GraphQLEpisodesDataSource: EpisodesRemoteDataSource {
    var pageSize: UInt = 20

    let apolloClient: ApolloClient

    init(apolloClient: ApolloClient) {
        self.apolloClient = apolloClient
    }

    func getEpisodes(page: UInt, filter: EpisodeFilter) async -> Result<PaginatedResponse<EpisodeSeason>, Error> {
        let result = await apolloClient.fetchAsync(query: EpisodesQuery(page: Int(page), filter: FilterEpisode.from(filter: filter)))
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

        let seasons: [EpisodeSeason] = Dictionary(grouping: domainEpisodes, by: {
            UInt16($0.seasonId.slice(from: "S", to: "E")!)!
        }).map { key, episodes in
            EpisodeSeason(id: key, episodes: episodes)
        }

        return .success(PaginatedResponse(items: seasons, hasNext: info.next != nil))
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
