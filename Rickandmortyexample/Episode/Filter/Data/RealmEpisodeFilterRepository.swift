import RealmSwift
import RxSwift

class RealmEpisodeFilterRepository: EpisodeFilterRepository {

    let realmFactory: RealmFactory
    let realmQueue: DispatchQueue

    private let maxFilters = 5

    init(realmFactory: RealmFactory, realmQueue: DispatchQueue) {
        self.realmFactory = realmFactory
        self.realmQueue = realmQueue
    }

    static func preload(realm: Realm) throws {
        let filters = realm.objects(RealmEpisodeFilter.self)
        if filters.count > 0 { return }

        try realm.write {
            let defaultFilter = RealmEpisodeFilter(filter: EpisodeFilter())
            realm.add(defaultFilter)
        }
    }

    func getLatestFilter() async -> EpisodeFilter {
        return await withCheckedContinuation { continuation in
            realmQueue.async {
                do {
                    let realm = try self.realmFactory.build()

                    let filter = realm.objects(RealmEpisodeFilter.self)
                        .sorted(by: \.createdAt, ascending: false)
                        .first?.toDomain()

                    return continuation.resume(returning: filter ?? EpisodeFilter())
                } catch {
                    return continuation.resume(returning: EpisodeFilter())
                }
            }
        }
    }

    func getLatestFilterObservable() -> Observable<EpisodeFilter> {
        return Observable.create { observer in
            var subscription: NotificationToken? = .none

            do {
                let realm = try self.realmFactory.buildWithoutQueue()
                let filters = realm.objects(RealmEpisodeFilter.self)

                subscription = filters
                    .observe { changes in
                        if case .error = changes { return }
                        Task {
                            let filter = await self.getLatestFilter()
                            observer.onNext(filter)
                        }
                    }
            } catch {}

            return Disposables.create {
                subscription?.invalidate()
            }
        }
    }

    func addFilter(filter: EpisodeFilter) async {
        return await withCheckedContinuation { continuation in
            realmQueue.async {
                defer {
                    continuation.resume(returning: ())
                }

                do {
                    let realm = try self.realmFactory.build()
                    let realmFilter = RealmEpisodeFilter(filter: filter)

                    try realm.write {
                        let filters = realm.objects(RealmEpisodeFilter.self)

                        let existingFilter = filters.where { $0.primaryId == realmFilter.primaryId }.first
                        if let existingFilter = existingFilter {
                            existingFilter.createdAt = realmFilter.createdAt
                            return
                        }

                        if filters.count >= self.maxFilters {
                            let oldestFilter = filters.sorted(by: \.createdAt, ascending: true).first
                            oldestFilter?.delete(realm: realm)
                        }

                        realm.add(realmFilter)
                    }
                } catch { }
            }
        }
    }
}
