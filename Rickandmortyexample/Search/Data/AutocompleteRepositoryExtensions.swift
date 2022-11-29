import Apollo

extension AutocompleteRepository {
    func fetchAutocompletions<Query: GraphQLQuery>(apolloClient: ApolloClient, query: Query, mapAutocompletions: @escaping (_ data: Query.Data?) -> [String]) async -> Result<[String], Error> {
        let result = await apolloClient.fetchAsync(query: query)

        guard let result = result.unwrap() else {
            return .failure(
                Error(message: result.failure()!.localizedDescription)
            )
        }

        let autocompletions = Array(Set(mapAutocompletions(result.data)))

        return .success(autocompletions)
    }
}
