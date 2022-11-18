protocol CharactersRemoteDataSource {
    var numPages: Int? { get }
    var pageSize: Int { get }
    func getCharacters(page: Int) async -> Result<[CharacterSummary], Error>
}
