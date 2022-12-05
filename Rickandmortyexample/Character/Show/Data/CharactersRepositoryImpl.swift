import RxSwift

class CharactersRepositoryImpl: CharactersRepository {
    let remoteDataSource: CharactersRemoteDataSource
    let localDataSource: CharactersLocalDataSource

    init(remoteDataSource: CharactersRemoteDataSource, localDataSource: CharactersLocalDataSource) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func fetch(filter: CharacterFilter) async -> Result<PaginatedResponse<CharacterSummary>, Error> {
        let localCharacters = await localDataSource.getCharacters(filter: filter)
        if let localCharacters = localCharacters {
            return .success(PaginatedResponse(items: localCharacters, hasNext: true))
        }

        return await refetch(filter: filter)
    }

    func fetchNextPage(
        filter: CharacterFilter,
        listSize: UInt32
    ) async -> Result<PaginatedResponse<CharacterSummary>, Error> {
        if listSize % remoteDataSource.pageSize > 0 { return .success(PaginatedResponse(items: [], hasNext: false)) }
        let page = UInt32(listSize / remoteDataSource.pageSize) + 1

        let characters = await remoteDataSource.getCharacters(page: page, filter: filter)
        guard let characters = characters.unwrap() else { return .failure(characters.failure()!)}

        await localDataSource.insertCharacters(characters: characters.items, filter: filter)

        return .success(characters)
    }

    func refetch(filter: CharacterFilter) async -> Result<PaginatedResponse<CharacterSummary>, Error> {
        let characters = await remoteDataSource.getCharacters(page: 1, filter: filter)
        guard let characters = characters.unwrap() else { return .failure(characters.failure()!)}

        await localDataSource.setCharacters(characters: characters.items, filter: filter)

        return .success(characters)
    }
}
