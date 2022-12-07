import RxSwift

protocol EpisodeDetailsLocalDataSource {
    func getObservable(id: String) -> Observable<EpisodeDetail>
    func upsertEpisodeDetail(detail: EpisodeDetail) async
    func existsEpisodeDetail(id: String) async -> Bool
}
