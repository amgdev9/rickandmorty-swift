import RxSwift

protocol CharacterDetailsRepository {
    func getObservable(id: String) -> Observable<Result<CharacterDetails, Error>>
    func refetch(id: String) async -> Result<Void, Error>
}
