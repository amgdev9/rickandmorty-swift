import RxSwift

protocol CharacterDetailsLocalDataSource {
    func getObservable(id: String) -> Observable<CharacterDetails>
    func upsertCharacterDetail(detail: CharacterDetails) async
    func existsCharacterDetails(id: String) async -> Bool
}
