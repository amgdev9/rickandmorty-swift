protocol CharactersRemoteDataSource {
    var pageSize: UInt { get }
    func getCharacters(page: UInt, filter: CharacterFilter) async -> Result<PaginatedResponse<CharacterSummary>, Error>
}
