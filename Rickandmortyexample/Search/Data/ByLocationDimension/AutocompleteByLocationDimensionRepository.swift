import Apollo

class AutocompleteByLocationDimensionRepository: AutocompleteRepository {
    let apolloClient: ApolloClient

    init(apolloClient: ApolloClient) {
        self.apolloClient = apolloClient
    }

    func getAutocompletions(search: String) async -> Result<[String], Error> {
        return await fetchAutocompletions(
            apolloClient: apolloClient,
            query: AutocompleteByLocationDimensionQuery(search: search),
            mapAutocompletions: {
                $0?.locations?.results?.map { $0?.dimension }.compactMap { $0 } ?? []
            })
    }
}
