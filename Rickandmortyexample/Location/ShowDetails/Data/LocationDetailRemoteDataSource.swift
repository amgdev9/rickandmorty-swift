protocol LocationDetailRemoteDataSource {
    func getLocationDetail(id: String) async -> Result<LocationDetail, Error>
}
