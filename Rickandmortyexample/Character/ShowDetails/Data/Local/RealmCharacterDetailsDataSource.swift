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
                    .where { $0.summary.primaryId.equals(RealmCharacterSummary.primaryId(id: id)) }
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
        print("Realm.getCharacterDetail \(id)")
        return await withCheckedContinuation { continuation in
            realmQueue.async {
                do {
                    let realm = try self.realmFactory.build()
                    let detail = realm.objects(RealmCharacterDetails.self)
                        .where { $0.summary.primaryId.equals(RealmCharacterSummary.primaryId(id: id)) }
                        .first
                    print("\(detail != nil)")
                    return continuation.resume(returning: detail?.toDomain())
                } catch {}
            }
        }
    }

    func upsertCharacterDetail(detail: CharacterDetails) async {
        print("Realm.upsertCharacterDetail \(detail.id)")
        return await withCheckedContinuation { continuation in
            realmQueue.async {
                do {
                    let realm = try self.realmFactory.build()

                    try realm.write {
                        let summary = realm.objects(RealmCharacterSummary.self)
                            .where { $0.primaryId.equals(RealmCharacterSummary.primaryId(id: detail.id)) }

                        let realmDetail = RealmCharacterDetails(detail: detail)
                        if let origin = detail.origin {
                            realmDetail.origin = RealmLocationSummary(characterLocation: origin)
                        }
                        if let location = detail.location {
                            realmDetail.location = RealmLocationSummary(characterLocation: location)
                        }
                        realmDetail.episodes.append(objectsIn: detail.episodes.map { RealmEpisodeSummary(episodeSummary: $0) })

                        summary.first?.detail = realmDetail

                        realm.add(realmDetail, update: .modified)
                    }
                } catch {}
                continuation.resume(returning: ())
            }
        }
    }

    func existsCharacterDetails(id: String) async -> Bool {
        print("Realm.existsCharacterDetails \(id)")
        return await withCheckedContinuation { continuation in
            realmQueue.async {
                do {
                    let realm = try self.realmFactory.build()
                    let exists = realm.objects(RealmCharacterDetails.self)
                        .where { $0.summary.primaryId.equals(RealmCharacterSummary.primaryId(id: id)) }
                        .count > 0
                    print("\(exists)")
                    return continuation.resume(returning: exists)
                } catch {}
            }
        }
    }
}
