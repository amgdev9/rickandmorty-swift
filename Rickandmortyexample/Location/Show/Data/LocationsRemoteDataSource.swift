protocol LocationsRemoteDataSource {
    var pageSize: UInt32 { get }
    func getLocations(page: UInt32, filter: LocationFilter) async -> Result<PaginatedResponse<LocationSummary>, Error>
}
