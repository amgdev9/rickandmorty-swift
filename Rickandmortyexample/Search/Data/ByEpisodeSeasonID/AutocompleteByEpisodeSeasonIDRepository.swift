import Apollo

class AutocompleteByEpisodeSeasonIDRepository: AutocompleteRepository {
    let apolloClient: ApolloClient

    init(apolloClient: ApolloClient) {
        self.apolloClient = apolloClient
    }

    func getAutocompletions(search: String) async -> Result<[String], Error> {
        return await fetchAutocompletions(
            apolloClient: apolloClient,
            query: AutocompleteByEpisodeSeasonIDQuery(search: search),
            mapAutocompletions: {
                $0?.episodes?.results?.map { $0?.episode }.compactMap { $0 } ?? []
            })
    }
}
