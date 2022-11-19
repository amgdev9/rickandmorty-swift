protocol CharactersRemoteDataSource {
    var numPages: UInt? { get }
    var pageSize: UInt { get }
    func getCharacters(page: UInt) async -> Result<[CharacterSummary], Error>
}
