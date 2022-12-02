import RxSwift
import RealmSwift

class RealmCharacterDetailsDataSource: CharacterDetailsLocalDataSource {
    let realmFactory: RealmFactory
    let realmQueue: DispatchQueue

    init(realmFactory: RealmFactory, realmQueue: DispatchQueue) {
        self.realmFactory = realmFactory
        self.realmQueue = realmQueue
    }

    func getObservable(id: String) -> Observable<CharacterDetails> {
        return .create { observer in
            var subscription: NotificationToken? = .none
            do {
                let realm = try self.realmFactory.buildWithoutQueue()
                subscription = realm.objects(RealmCharacterDetails.self)
                    .where { $0.summary.id.equals(id) }
                    .observe { changes in
                        if case .error = changes { return }
                        Task {
                            let detail = await self.getCharacterDetail(id: id)
                            guard let detail = detail else { return }

                            observer.onNext(detail)
                        }
                    }
            } catch {}

            return Disposables.create {
                subscription?.invalidate()
            }
        }
    }

    private func getCharacterDetail(id: String) async -> CharacterDetails? {
        return await withCheckedContinuation { continuation in
            realmQueue.async {
                do {
                    let realm = try self.realmFactory.build()
                    let detail = realm.objects(RealmCharacterDetails.self)
                        .where { $0.summary.id.equals(id) }
                        .first
                    return continuation.resume(returning: detail?.toDomain())
                } catch {}
            }
        }
    }

    func upsertCharacterDetail(detail: CharacterDetails) async {
        return await withCheckedContinuation { continuation in
            realmQueue.async {
                do {
                    let realm = try self.realmFactory.build()

                    let detail = RealmCharacterDetails(detail: detail)
                    try realm.write {
                        realm.add(detail, update: .modified)
                    }
                } catch {}
                continuation.resume(returning: ())
            }
        }
    }

    func existsCharacterDetails(id: String) async -> Bool {
        return await withCheckedContinuation { continuation in
            realmQueue.async {
                do {
                    let realm = try self.realmFactory.build()
                    let exists = realm.objects(RealmCharacterDetails.self)
                        .where { $0.summary.id.equals(id) }
                        .count > 0
                    return continuation.resume(returning: exists)
                } catch {}
            }
        }
    }
}
