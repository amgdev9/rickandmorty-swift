import RxSwift

protocol CharactersLocalDataSource {
    var observable: Observable<[CharacterSummary]> { get }

    func getCharactersCount() async -> Result<UInt, Error>
    func getCharacters() async -> Result<[CharacterSummary], Error>
    func insertCharacters(characters: [CharacterSummary], numExpectedCharacters: UInt) async -> Result<Void, Error>
    func setCharacters(characters: [CharacterSummary]) async -> Result<Void, Error>
}
