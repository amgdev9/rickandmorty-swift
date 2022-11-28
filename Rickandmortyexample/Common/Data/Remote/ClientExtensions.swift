import Apollo

extension ApolloClient {
    public func fetch<Query: GraphQLQuery>(query: Query, resultHandler: GraphQLResultHandler<Query.Data>? = nil) -> Cancellable {
        return fetch(query: query, cachePolicy: .fetchIgnoringCacheCompletely, resultHandler: resultHandler)
    }
}
