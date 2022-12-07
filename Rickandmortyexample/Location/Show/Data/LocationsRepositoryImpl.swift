import RxSwift

class LocationsRepositoryImpl: LocationsRepository {
    let remoteDataSource: LocationsRemoteDataSource
    let localDataSource: LocationsLocalDataSource

    init(remoteDataSource: LocationsRemoteDataSource, localDataSource: LocationsLocalDataSource) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func fetch(filter: LocationFilter) async -> Result<PaginatedResponse<LocationSummary>, Error> {
        let localLocations = await localDataSource.getLocations(filter: filter)
        if let localLocations = localLocations {
            return .success(PaginatedResponse(items: localLocations, hasNext: true))
        }

        return await refetch(filter: filter)
    }

    func fetchNextPage(
        filter: LocationFilter,
        listSize: UInt32
    ) async -> Result<PaginatedResponse<LocationSummary>, Error> {
        if listSize % remoteDataSource.pageSize > 0 { return .success(PaginatedResponse(items: [], hasNext: false)) }
        let page = UInt32(listSize / remoteDataSource.pageSize) + 1

        let locations = await remoteDataSource.getLocations(page: page, filter: filter)
        guard let locations = locations.unwrap() else { return .failure(locations.failure()!)}

        await localDataSource.insertLocations(locations: locations.items, filter: filter)

        return .success(locations)
    }

    func refetch(filter: LocationFilter) async -> Result<PaginatedResponse<LocationSummary>, Error> {
        let locations = await remoteDataSource.getLocations(page: 1, filter: filter)
        guard let locations = locations.unwrap() else { return .failure(locations.failure()!)}

        await localDataSource.setLocations(locations: locations.items, filter: filter)

        return .success(locations)
    }
}
