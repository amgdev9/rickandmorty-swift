import RxSwift

protocol EpisodeFilterRepository {
    func getLatestFilter() async -> EpisodeFilter
    func getLatestFilterObservable() -> Observable<EpisodeFilter>
    func addFilter(filter: EpisodeFilter) async
}
