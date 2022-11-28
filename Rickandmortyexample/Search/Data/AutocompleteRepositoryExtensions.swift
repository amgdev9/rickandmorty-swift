import Apollo

extension AutocompleteRepository {
    func fetchAutocompletions<Query: GraphQLQuery>(apolloClient: ApolloClient, query: Query, mapAutocompletions: @escaping (_ data: Query.Data?) -> [String]) async -> Result<[String], Error> {
        var cancellable: Cancellable? = .none
        return await withTaskCancellationHandler { [cancellable] in
            cancellable?.cancel()
        } operation: {
            return await withCheckedContinuation { continuation in
                cancellable = apolloClient.fetch(query: query) { result in
                    guard let result = result.unwrap() else {
                        return continuation.resume(returning: .failure(
                            Error(message: result.failure()!.localizedDescription))
                        )
                    }

                    let autocompletions = Array(Set(mapAutocompletions(result.data)))

                    continuation.resume(returning: .success(autocompletions))
                }
            }
        }
    }
}
