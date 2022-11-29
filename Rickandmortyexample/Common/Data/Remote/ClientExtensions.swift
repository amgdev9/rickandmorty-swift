import Apollo

extension ApolloClient {
    public func fetchAsync<Query: GraphQLQuery>(query: Query) async -> Result<GraphQLResult<Query.Data>, Swift.Error> {
        var cancellable: Cancellable? = .none
        return await withTaskCancellationHandler { [cancellable] in
            cancellable?.cancel()
        } operation: {
            return await withCheckedContinuation { continuation in
                cancellable = self.fetch(
                    query: query,
                    cachePolicy: .fetchIgnoringCacheCompletely,
                    queue: DispatchQueue.global(qos: .userInitiated)
                ) { result in
                    continuation.resume(returning: result)
                }
            }
        }
    }
}
