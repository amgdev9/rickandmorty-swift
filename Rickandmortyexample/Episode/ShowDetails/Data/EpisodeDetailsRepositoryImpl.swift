import RxSwift

class EpisodeDetailsRepositoryImpl: EpisodeDetailsRepository {
    private let remoteDataSource: EpisodeDetailRemoteDataSource
    private let localDataSource: EpisodeDetailsLocalDataSource

    init(remoteDataSource: EpisodeDetailRemoteDataSource, localDataSource: EpisodeDetailsLocalDataSource) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func getObservable(id: String) -> Observable<Result<EpisodeDetail, Error>> {
        return .create { observer in
            let subscription = self.localDataSource.getObservable(id: id)
                .subscribe(onNext: {
                    observer.onNext(.success($0))
                })

            Task {
                let episodeExists = await self.localDataSource.existsEpisodeDetail(id: id)
                if episodeExists { return }

                let remoteDetails = await self.remoteDataSource.getEpisodeDetail(id: id)
                guard let remoteDetails = remoteDetails.unwrap() else {
                    return observer.onNext(.failure(remoteDetails.failure()!))
                }

                await self.localDataSource.upsertEpisodeDetail(detail: remoteDetails)
            }

            return Disposables.create {
                subscription.dispose()
            }
        }
    }

    func refetch(id: String) async -> Result<Void, Error> {
        let detail = await remoteDataSource.getEpisodeDetail(id: id)
        guard let detail = detail.unwrap() else { return .failure(detail.failure()!) }

        await localDataSource.upsertEpisodeDetail(detail: detail)

        return .success(())
    }
}
