import RxSwift

class CharactersRepositoryImpl: CharactersRepository {
    let remoteDataSource: CharactersRemoteDataSource
    let localDataSource: CharactersLocalDataSource

    var observable: Observable<Result<[CharacterSummary], Error>>

    init(remoteDataSource: CharactersRemoteDataSource, localDataSource: CharactersLocalDataSource) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource

        observable = .create { observer in
            let localDataSourceSubscription = localDataSource.observable.subscribe(onNext: { localCharacters in
                observer.onNext(.success(localCharacters))
            })

            let task = Task {
                let numPages = await localDataSource.getNumPages()
                guard let numPages = numPages.unwrap() else {
                    observer.onNext(.failure(numPages.failure()!))
                    return
                }

                if numPages == nil { return }

                let localCharacters = await localDataSource.getCharacters()

                guard let localCharacters = localCharacters.unwrap() else {
                    observer.onNext(.failure(localCharacters.failure()!))
                    return
                }

                observer.onNext(.success(localCharacters))
            }

            return Disposables.create {
                task.cancel()
                localDataSourceSubscription.dispose()
            }
        }
    }

    func fetch() async -> Result<Void, Error> {
        let numPages = await localDataSource.getNumPages()
        guard let numPages = numPages.unwrap() else { return .failure(numPages.failure()!)}
        if numPages != nil { return .success(()) }

        let response = await remoteDataSource.getCharacters(page: 1, filter: CharacterFilter()) // TODO Filter
        guard let response = response.unwrap() else {
            return .failure(response.failure()!)
        }

        let result = await localDataSource.setCharacters(characters: response.characters, numPages: response.numPages)
        if let error = result.failure() {
            return .failure(error)
        }

        return .success(())
    }

    func loadNextPage() async -> Result<Void, Error> {
        let numCharacters = await localDataSource.getCharactersCount()
        guard let numCharacters = numCharacters.unwrap() else { return .failure(numCharacters.failure()!)}

        if numCharacters == 0 { return .success(()) }

        let numPages = await localDataSource.getNumPages()
        guard let numPages = numPages.unwrap() else { return .failure(numPages.failure()!)}
        guard let numPages = numPages else { return .success(()) }

        let isLastPageLoaded = (numCharacters % remoteDataSource.pageSize) > 0
        if isLastPageLoaded { return .success(()) }

        let nextPage = numCharacters / remoteDataSource.pageSize + 1
        if nextPage > numPages { return .success(()) }

        let response = await remoteDataSource.getCharacters(page: nextPage, filter: CharacterFilter())    // TODO Filter
        guard let response = response.unwrap() else { return .failure(response.failure()!) }

        let result = await localDataSource.insertCharacters(characters: response.characters,
                                                            numExpectedCharacters: numCharacters,
                                                            numPages: response.numPages)
        if let error = result.failure() {
            return .failure(error)
        }

        return .success(())
    }

    func refetch() async -> Result<Void, Error> {
        let response = await remoteDataSource.getCharacters(page: 1, filter: CharacterFilter())   // TODO Filter
        guard let response = response.unwrap() else { return .failure(response.failure()!)}

        return await localDataSource.setCharacters(characters: response.characters, numPages: response.numPages)
    }
}
