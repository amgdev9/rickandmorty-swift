import RxSwift

protocol EpisodeDetailsRepository {
    func getObservable(id: String) -> Observable<Result<EpisodeDetail, Error>>
    func refetch(id: String) async -> Result<Void, Error>
}
