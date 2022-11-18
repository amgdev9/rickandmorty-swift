import RxSwift

protocol CharactersLocalDataSource {
    var observable: Observable<[CharacterSummary]> { get }

    func getCharactersCount() -> Result<Int, Error>
    func getCharacters() -> Result<[CharacterSummary], Error>
    func insertCharacters(characters: [CharacterSummary]) -> Result<Void, Error>
    func setCharacters(characters: [CharacterSummary]) -> Result<Void, Error>
}
