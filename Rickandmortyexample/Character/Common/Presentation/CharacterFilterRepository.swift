import RxSwift

protocol CharacterFilterRepository {
    func getLatestFilter() async -> CharacterFilter?
    func getLatestFilterObservable() -> Observable<CharacterFilter>
    func addFilter(filter: CharacterFilter) async
}
