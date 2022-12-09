import RxSwift
import RealmSwift

class RealmEpisodeDetailsDataSource: EpisodeDetailsLocalDataSource {
    let realmFactory: RealmFactory
    let realmQueue: DispatchQueue

    init(realmFactory: RealmFactory, realmQueue: DispatchQueue) {
        self.realmFactory = realmFactory
        self.realmQueue = realmQueue
    }

    func getObservable(id: String) -> Observable<EpisodeDetail> {
        return .create { observer in
            var subscription: NotificationToken? = .none
            do {
                let realm = try self.realmFactory.buildWithoutQueue()
                subscription = realm.objects(RealmEpisodeDetails.self)
                    .where { $0.summary.primaryId.equals(RealmEpisodeSummary.primaryId(id: id)) }
                    .observe { changes in
                        if case .error = changes { return }
                        Task {
                            let detail = await self.getEpisodeDetail(id: id)
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

    private func getEpisodeDetail(id: String) async -> EpisodeDetail? {
        return await realmQueue.runAsync { continuation in
            do {
                let realm = try self.realmFactory.build()
                let detail = realm.objects(RealmEpisodeDetails.self)
                    .where { $0.summary.primaryId.equals(RealmEpisodeSummary.primaryId(id: id)) }
                    .first
                return continuation.resume(returning: detail?.toDomain())
            } catch {
                return continuation.resume(returning: .none)
            }
        }
    }

    func upsertEpisodeDetail(detail: EpisodeDetail) async {
        return await realmQueue.runAsync { continuation in
            defer {
                continuation.resume(returning: ())
            }

            do {
                let realm = try self.realmFactory.build()

                try realm.write {
                    let summary = realm.objects(RealmEpisodeSummary.self)
                        .where { $0.primaryId.equals(RealmEpisodeSummary.primaryId(id: detail.id)) }
                        .first

                    if let summary = summary {
                        let realmDetail = self.buildEpisodeDetail(detail: detail, realm: realm)
                        realm.add(realmDetail, update: .modified)
                        summary.detail = realmDetail
                    } else {
                        let summary = EpisodeSummary(
                            id: detail.id,
                            seasonId: detail.seasonID,
                            name: detail.name,
                            date: detail.date
                        )

                        let realmSummary = RealmEpisodeSummary(episodeSummary: summary)
                        let realmDetail = self.buildEpisodeDetail(detail: detail, realm: realm)

                        realmSummary.detail = realmDetail
                        realm.add(realmSummary)

                        let latestFilter = realm.objects(RealmEpisodeFilter.self)
                            .sorted(by: \.createdAt, ascending: false)
                            .first!

                        let list = realm.objects(RealmEpisodeList.self)
                            .where { $0.filter.primaryId.equals(latestFilter.primaryId) }
                            .first! // List must exist here

                        list.uncachedEpisodes.append(realmSummary)
                    }
                }
            } catch {}
        }
    }

    private func buildEpisodeDetail(detail: EpisodeDetail, realm: Realm) -> RealmEpisodeDetails {
        let realmDetail = RealmEpisodeDetails(detail: detail)

        let realmCharacters = detail.characters.map { RealmCharacterSummary(character: $0) }
        realmCharacters.forEach {
            realm.add($0, update: .modified)
        }
        realmDetail.characters.append(objectsIn: realmCharacters)

        return realmDetail
    }

    func existsEpisodeDetail(id: String) async -> Bool {
        return await realmQueue.runAsync { continuation in
            do {
                let realm = try self.realmFactory.build()
                let exists = realm.objects(RealmEpisodeDetails.self)
                    .where { $0.summary.primaryId.equals(RealmEpisodeSummary.primaryId(id: id)) }
                    .count > 0
                return continuation.resume(returning: exists)
            } catch {
                continuation.resume(returning: false)
            }
        }
    }
}
