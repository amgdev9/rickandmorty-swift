protocol CharactersRemoteDataSource {
    var pageSize: UInt { get }
    func getCharacters(page: UInt, filter: CharacterFilter) async -> Result<CharactersResponse, Error>
}

class CharactersResponse {
    let numPages: UInt32
    let characters: [CharacterSummary]

    init(numPages: UInt32, characters: [CharacterSummary]) {
        self.numPages = numPages
        self.characters = characters
    }
}
