import RxSwift

protocol LocationDetailLocalDataSource {
    func getObservable(id: String) -> Observable<LocationDetail>
    func upsertLocationDetail(detail: LocationDetail) async
    func existsLocationDetail(id: String) async -> Bool
}
