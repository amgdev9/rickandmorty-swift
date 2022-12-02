import RxSwift

class CharacterDetailsRepositoryImpl: CharacterDetailsRepository {
    private let remoteDataSource: CharacterDetailRemoteDataSource
    private let localDataSource: CharacterDetailsLocalDataSource

    init(remoteDataSource: CharacterDetailRemoteDataSource, localDataSource: CharacterDetailsLocalDataSource) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func getObservable(id: String) -> Observable<Result<CharacterDetails, Error>> {
        return Observable.create { observer in
            let subscription = self.localDataSource.getObservable(id: id)
                .subscribe(onNext: {
                    observer.onNext(.success($0))
                })

            Task {
                let characterExists = await self.localDataSource.existsCharacterDetails(id: id)
                if characterExists { return }

                let remoteDetails = await self.remoteDataSource.getCharacterDetail(id: id)
                guard let remoteDetails = remoteDetails.unwrap() else { return observer.onNext(.failure(remoteDetails.failure()!)) }

                await self.localDataSource.upsertCharacterDetail(detail: remoteDetails)
            }

            return Disposables.create {
                subscription.dispose()
            }
        }
    }

    func refetch(id: String) async -> Result<Void, Error> {
        let detail = await remoteDataSource.getCharacterDetail(id: id)
        guard let detail = detail.unwrap() else { return .failure(detail.failure()!) }

        await localDataSource.upsertCharacterDetail(detail: detail)

        return .success(())
    }
}
