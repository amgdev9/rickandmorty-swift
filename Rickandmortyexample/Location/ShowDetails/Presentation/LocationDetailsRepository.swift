import RxSwift

protocol LocationDetailsRepository {
    func getObservable(id: String) -> Observable<Result<LocationDetail, Error>>
    func refetch(id: String) async -> Result<Void, Error>
}
