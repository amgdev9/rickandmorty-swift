import Apollo

class GraphQLLocationsDataSource: LocationsRemoteDataSource {
    var pageSize: UInt = 20

    let apolloClient: ApolloClient

    init(apolloClient: ApolloClient) {
        self.apolloClient = apolloClient
    }

    func getLocations(page: UInt, filter: LocationFilter) async -> Result<PaginatedResponse<LocationSummary>, Error> {
        var cancellable: Cancellable? = .none
        return await withTaskCancellationHandler { [cancellable] in
            cancellable?.cancel()
        } operation: {
            return await withCheckedContinuation { continuation in
                cancellable = apolloClient.fetch(
                    query: LocationsQuery(page: Int(page), filter: FilterLocation.from(filter: filter))
                ) { result in
                    guard let result = result.unwrap() else {
                        return continuation.resume(returning: .failure(Error(message: result.failure()!.localizedDescription)))
                    }

                    guard let locations = result.data?.locations?.results else {
                        return continuation.resume(returning: .failure(Error(message: String(localized: "error/unknown"))))
                    }

                    guard let pages = result.data?.locations?.info?.pages else {
                        return continuation.resume(returning: .failure(Error(message: String(localized: "error/unknown"))))
                    }

                    let domainCharacters = locations
                        .compactMap { $0 }
                        .map { $0.fragments.locationSummaryFragment.toDomain() }
                    continuation.resume(returning:
                            .success(PaginatedResponse(numPages: UInt32(pages), items: domainCharacters))
                    )
                }
            }
        }
    }
}

extension FilterLocation {
    // TODO This is used in multiple places
    static func mapString(_ value: String) -> GraphQLNullable<String> {
        if value.isEmpty { return .none }
        return .some(value)
    }

    static func from(filter: LocationFilter) -> Self {
        return FilterLocation(
            name: mapString(filter.name),
            type: mapString(filter.type),
            dimension: mapString(filter.dimension)
        )
    }
}
