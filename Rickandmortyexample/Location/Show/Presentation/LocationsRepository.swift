import RxSwift

protocol LocationsRepository {
    func fetch(filter: LocationFilter) async -> Result<PaginatedResponse<LocationSummary>, Error>
    func fetchNextPage(
        filter: LocationFilter,
        listSize: UInt32
    ) async -> Result<PaginatedResponse<LocationSummary>, Error>
    func refetch(filter: LocationFilter) async -> Result<PaginatedResponse<LocationSummary>, Error>
}
