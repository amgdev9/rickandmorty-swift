import Apollo

class AutocompleteByCharacterNameRepository: AutocompleteRepository {
    let apolloClient: ApolloClient

    init(apolloClient: ApolloClient) {
        self.apolloClient = apolloClient
    }

    func getAutocompletions(search: String) async -> Result<[String], Error> {
        return await fetchAutocompletions(
            apolloClient: apolloClient,
            query: AutocompleteByCharacterNameQuery(search: search),
            mapAutocompletions: {
                $0?.characters?.results?.map { $0?.name }.compactMap { $0 } ?? []
            })
    }
}
