class GraphQLLocationDetailDataSource: LocationDetailRemoteDataSource {
    let apolloClient: ApolloClient

    init(apolloClient: ApolloClient) {
        self.apolloClient = apolloClient
    }

    func getLocationDetail(id: String) async -> Result<LocationDetail, Error> {
        let result = await apolloClient.fetchAsync(query: LocationDetailQuery(id: id))
        guard let result = result.unwrap() else {
            return .failure(Error(message: result.failure()!.localizedDescription))
        }

        guard let location = result.data?.location else {
            return .failure(Error(message: String(localized: "error/unknown")))
        }

        return .success(location.toDomain())
    }
}

extension LocationDetailQuery.Data.Location {
    func toDomain() -> LocationDetail {
        let summary = fragments.locationSummaryFragment.toDomain()
        return LocationDetail.Builder()
            .set(id: summary.id)
            .set(name: summary.name)
            .set(type: summary.type)
            .set(dimension: dimension ?? String(localized: "misc/unknown"))
            .set(residents: residents.compactMap{ $0 }.map { $0.fragments.characterSummaryFragment.toDomain() })
            .build()
    }
}
