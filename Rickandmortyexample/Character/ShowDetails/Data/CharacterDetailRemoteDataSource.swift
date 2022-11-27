protocol CharacterDetailRemoteDataSource {
    func getCharacterDetail(id: String) async -> Result<CharacterDetails, Error>
}
