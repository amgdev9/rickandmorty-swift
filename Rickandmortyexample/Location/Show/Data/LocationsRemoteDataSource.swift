protocol LocationsRemoteDataSource {
    var pageSize: UInt { get }
    func getLocations(page: UInt, filter: LocationFilter) async -> Result<PaginatedResponse<LocationSummary>, Error>
}
