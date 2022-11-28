import Apollo

class AutocompleteByLocationTypeRepository: AutocompleteRepository {
    let apolloClient: ApolloClient

    init(apolloClient: ApolloClient) {
        self.apolloClient = apolloClient
    }

    func getAutocompletions(search: String) async -> Result<[String], Error> {
        return await fetchAutocompletions(
            apolloClient: apolloClient,
            query: AutocompleteByLocationTypeQuery(search: search),
            mapAutocompletions: {
                $0?.locations?.results?.map { $0?.type }.compactMap { $0 } ?? []
            })
    }
}
