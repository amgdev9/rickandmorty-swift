import RxSwift

class CharactersRepositoryImpl: CharactersRepository {
    let remoteDataSource: CharactersRemoteDataSource
    let localDataSource: CharactersLocalDataSource

    let observable: Observable<Result<[CharacterSummary], Error>>

    init(remoteDataSource: CharactersRemoteDataSource, localDataSource: CharactersLocalDataSource) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource

        observable = .create { observer in
            let localDataSourceSubscription = localDataSource.observable.subscribe(onNext: { localCharacters in
                observer.onNext(.success(localCharacters))
            })

            let task = Task {
                let numPages = remoteDataSource.numPages
                let localCharacters = await localDataSource.getCharacters()

                if let error = localCharacters.failure() {
                    observer.onNext(.failure(error))
                    return
                }

                if numPages != .none {
                    observer.onNext(.success(localCharacters.unwrap()!))
                    return
                }

                let remoteCharacters = await remoteDataSource.getCharacters(page: 1)
                if let error = remoteCharacters.failure() {
                    observer.onNext(.failure(error))
                    return
                }

                let result = await localDataSource.setCharacters(characters: remoteCharacters.unwrap()!)
                if let error = result.failure() {
                    observer.onNext(.failure(error))
                    return
                }
            }

            return Disposables.create {
                task.cancel()
                localDataSourceSubscription.dispose()
            }
        }
    }

    func loadNextPage() async -> Result<Void, Error> {
        let numCharactersResult = await localDataSource.getCharactersCount()
        if let error = numCharactersResult.failure() {
            return .failure(error)
        }
        let numCharacters = numCharactersResult.unwrap()!

        if numCharacters == 0 { return .success(()) }
        guard let numPages = remoteDataSource.numPages else { return .success(()) }

        let isLastPageLoaded = (numCharacters % remoteDataSource.pageSize) > 0
        if isLastPageLoaded { return .success(()) }

        let nextPage = numCharacters / remoteDataSource.pageSize + 1
        if nextPage > numPages { return .success(()) }

        let characters = await remoteDataSource.getCharacters(page: nextPage)
        if let error = characters.failure() {
            return .failure(error)
        }

        let result = await localDataSource.insertCharacters(characters: characters.unwrap()!,
                                                            numExpectedCharacters: numCharacters)
        if let error = result.failure() {
            return .failure(error)
        }

        return .success(())
    }

    func refetch() async -> Result<Void, Error> {
        let characters = await remoteDataSource.getCharacters(page: 1)

        if let error = characters.failure() {
            return .failure(error)
        }

        return await localDataSource.setCharacters(characters: characters.unwrap()!)
    }
}
