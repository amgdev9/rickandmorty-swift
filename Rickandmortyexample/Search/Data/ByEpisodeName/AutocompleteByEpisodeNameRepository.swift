import Apollo

class AutocompleteByEpisodeNameRepository: AutocompleteRepository {
    let apolloClient: ApolloClient

    init(apolloClient: ApolloClient) {
        self.apolloClient = apolloClient
    }

    func getAutocompletions(search: String) async -> Result<[String], Error> {
        return await fetchAutocompletions(
            apolloClient: apolloClient,
            query: AutocompleteByEpisodeNameQuery(search: search),
            mapAutocompletions: {
                $0?.episodes?.results?.map { $0?.name }.compactMap { $0 } ?? []
            })
    }
}
