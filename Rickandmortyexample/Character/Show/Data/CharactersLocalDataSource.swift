import RxSwift

protocol CharactersLocalDataSource {
    func insertCharacters(characters: [CharacterSummary], filter: CharacterFilter) async
    func setCharacters(characters: [CharacterSummary], filter: CharacterFilter) async
    func getCharacters(filter: CharacterFilter) async -> [CharacterSummary]?
}
