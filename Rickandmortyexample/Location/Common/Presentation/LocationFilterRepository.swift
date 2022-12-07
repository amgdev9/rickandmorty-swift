import RxSwift

protocol LocationFilterRepository {
    func getLatestFilter() async -> LocationFilter
    func getLatestFilterObservable() -> Observable<LocationFilter>
    func addFilter(filter: LocationFilter) async
}
