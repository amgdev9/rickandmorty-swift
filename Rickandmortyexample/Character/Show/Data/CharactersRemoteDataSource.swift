protocol CharactersRemoteDataSource {
    var pageSize: UInt32 { get }
    func getCharacters(
        page: UInt32,
        filter: CharacterFilter
    ) async -> Result<PaginatedResponse<CharacterSummary>, Error>
}
