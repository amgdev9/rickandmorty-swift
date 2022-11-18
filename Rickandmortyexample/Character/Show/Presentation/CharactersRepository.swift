import RxSwift

protocol CharactersRepository {
    var observable: Observable<Result<[CharacterSummary], Error>> { get }
    func loadNextPage() async -> Result<Void, Error>
    func refetch() async -> Result<Void, Error>
}
