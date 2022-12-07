import RxSwift
import RealmSwift

class RealmLocationDetailDataSource: LocationDetailLocalDataSource {
    let realmFactory: RealmFactory
    let realmQueue: DispatchQueue

    init(realmFactory: RealmFactory, realmQueue: DispatchQueue) {
        self.realmFactory = realmFactory
        self.realmQueue = realmQueue
    }

    func getObservable(id: String) -> Observable<LocationDetail> {
        return .create { observer in
            var subscription: NotificationToken? = .none
            do {
                let realm = try self.realmFactory.buildWithoutQueue()
                subscription = realm.objects(RealmLocationDetail.self)
                    .where { $0.summary.primaryId.equals(RealmLocationSummary.primaryId(id: id)) }
                    .observe { changes in
                        if case .error = changes { return }
                        Task {
                            let detail = await self.getLocationDetail(id: id)
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

    private func getLocationDetail(id: String) async -> LocationDetail? {
        return await withCheckedContinuation { continuation in
            realmQueue.async {
                do {
                    let realm = try self.realmFactory.build()
                    let detail = realm.objects(RealmLocationDetail.self)
                        .where { $0.summary.primaryId.equals(RealmLocationSummary.primaryId(id: id)) }
                        .first
                    return continuation.resume(returning: detail?.toDomain())
                } catch {
                    return continuation.resume(returning: .none)
                }
            }
        }
    }

    func upsertLocationDetail(detail: LocationDetail) async {
        return await withCheckedContinuation { continuation in
            realmQueue.async {
                defer {
                    continuation.resume(returning: ())
                }

                do {
                    let realm = try self.realmFactory.build()

                    try realm.write {
                        let summary = realm.objects(RealmLocationSummary.self)
                            .where { $0.primaryId.equals(RealmLocationSummary.primaryId(id: detail.id)) }
                            .first

                        if let summary = summary {
                            let realmDetail = self.buildLocationDetail(detail: detail, realm: realm)
                            realm.add(realmDetail, update: .modified)
                            summary.type = detail.type
                            summary.detail = realmDetail
                        } else {
                            let summary = LocationSummary.Builder()
                                .set(id: detail.id)
                                .set(type: detail.type)
                                .set(name: detail.name)
                                .build()

                            let realmSummary = RealmLocationSummary(locationSummary: summary)
                            let realmDetail = self.buildLocationDetail(detail: detail, realm: realm)

                            realmSummary.detail = realmDetail
                            realm.add(realmSummary)

                            let latestFilter = realm.objects(RealmLocationFilter.self)
                                .sorted(by: \.createdAt, ascending: false)
                                .first!

                            let list = realm.objects(RealmLocationList.self)
                                .where { $0.filter.primaryId.equals(latestFilter.primaryId) }
                                .first! // List must exist here

                            list.uncachedLocations.append(realmSummary)
                        }
                    }
                } catch {}
            }
        }
    }

    private func buildLocationDetail(detail: LocationDetail, realm: Realm) -> RealmLocationDetail {
        let realmDetail = RealmLocationDetail(detail: detail)

        let realmResidents = detail.residents.map { RealmCharacterSummary(character: $0) }
        realmResidents.forEach {
            realm.add($0, update: .modified)
        }
        realmDetail.residents.append(objectsIn: realmResidents)

        return realmDetail
    }

    func existsLocationDetail(id: String) async -> Bool {
        return await withCheckedContinuation { continuation in
            realmQueue.async {
                do {
                    let realm = try self.realmFactory.build()
                    let exists = realm.objects(RealmLocationDetail.self)
                        .where { $0.summary.primaryId.equals(RealmLocationSummary.primaryId(id: id)) }
                        .count > 0
                    return continuation.resume(returning: exists)
                } catch {
                    continuation.resume(returning: false)
                }
            }
        }
    }
}
