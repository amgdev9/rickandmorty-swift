import RxSwift

protocol CharactersLocalDataSource {
    var observable: Observable<[CharacterSummary]> { get }

    func getCharactersCount() async -> Result<UInt, Error>
    func getCharacters() async -> Result<[CharacterSummary], Error>
    func insertCharacters(characters: [CharacterSummary], numExpectedCharacters: UInt, numPages: UInt32) async -> Result<Void, Error>
    func setCharacters(characters: [CharacterSummary], numPages: UInt32) async -> Result<Void, Error>
    func getNumPages() async -> Result<UInt32?, Error>
}
