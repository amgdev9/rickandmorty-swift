protocol EpisodeDetailRemoteDataSource {
    func getEpisodeDetail(id: String) async -> Result<EpisodeDetail, Error>
}
