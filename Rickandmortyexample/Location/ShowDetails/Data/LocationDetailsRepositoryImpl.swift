import RxSwift

class LocationDetailsRepositoryImpl: LocationDetailsRepository {
    private let remoteDataSource: LocationDetailRemoteDataSource
    private let localDataSource: LocationDetailLocalDataSource

    init(remoteDataSource: LocationDetailRemoteDataSource, localDataSource: LocationDetailLocalDataSource) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func getObservable(id: String) -> Observable<Result<LocationDetail, Error>> {
        return Observable.create { observer in
            let subscription = self.localDataSource.getObservable(id: id)
                .subscribe(onNext: {
                    observer.onNext(.success($0))
                })

            Task {
                let locationExists = await self.localDataSource.existsLocationDetail(id: id)
                if locationExists { return }

                let remoteDetails = await self.remoteDataSource.getLocationDetail(id: id)
                guard let remoteDetails = remoteDetails.unwrap() else {
                    return observer.onNext(.failure(remoteDetails.failure()!))
                }

                await self.localDataSource.upsertLocationDetail(detail: remoteDetails)
            }

            return Disposables.create {
                subscription.dispose()
            }
        }
    }

    func refetch(id: String) async -> Result<Void, Error> {
        let detail = await remoteDataSource.getLocationDetail(id: id)
        guard let detail = detail.unwrap() else { return .failure(detail.failure()!) }

        await localDataSource.upsertLocationDetail(detail: detail)

        return .success(())
    }
}
