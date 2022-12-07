protocol LocationsLocalDataSource {
    func insertLocations(locations: [LocationSummary], filter: LocationFilter) async
    func setLocations(locations: [LocationSummary], filter: LocationFilter) async
    func getLocations(filter: LocationFilter) async -> [LocationSummary]?
}
