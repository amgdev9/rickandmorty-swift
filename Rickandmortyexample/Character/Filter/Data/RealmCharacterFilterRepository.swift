import RealmSwift
import RxSwift

class RealmCharacterFilterRepository: CharacterFilterRepository {

    let realmFactory: RealmFactory
    let realmQueue: DispatchQueue

    private let maxFilters = 5

    init(realmFactory: RealmFactory, realmQueue: DispatchQueue) {
        self.realmFactory = realmFactory
        self.realmQueue = realmQueue
    }

    func getLatestFilter() async -> CharacterFilter? {
        return await withCheckedContinuation { continuation in
            realmQueue.async {
                do {
                    let realm = try self.realmFactory.build()

                    let filter = realm.objects(RealmCharacterFilter.self)
                        .sorted(by: \.createdAt, ascending: false)
                        .first?.toDomain()

                    return continuation.resume(returning: filter)
                } catch { }

                return continuation.resume(returning: .none)
            }
        }
    }

    func getLatestFilterObservable() -> Observable<CharacterFilter> {
        return Observable.create { observer in
            var subscription: NotificationToken? = .none

            do {
                let realm = try self.realmFactory.buildWithoutQueue()
                let filters = realm.objects(RealmCharacterFilter.self)

                subscription = filters
                    .observe { changes in
                        if case .error = changes { return }
                        Task {
                            let filter = await self.getLatestFilter()
                            guard let filter = filter else { return }
                            observer.onNext(filter)
                        }
                    }
            } catch {}

            return Disposables.create {
                subscription?.invalidate()
            }
        }
    }

    func addFilter(filter: CharacterFilter) async {
        return await withCheckedContinuation { continuation in
            realmQueue.async {
                do {
                    let realm = try self.realmFactory.build()
                    let realmFilter = RealmCharacterFilter(filter: filter)

                    try realm.write {
                        let filters = realm.objects(RealmCharacterFilter.self)

                        let existingFilter = filters.where { $0.id == realmFilter.id }.first
                        if let existingFilter = existingFilter {
                            existingFilter.createdAt = realmFilter.createdAt
                            print("\(filters.count)")
                            return continuation.resume(returning: ())
                        }

                        if filters.count >= self.maxFilters {
                            let oldestFilter = filters.sorted(by: \.createdAt, ascending: true).first
                            oldestFilter?.delete(realm: realm)
                        }

                        realm.add(realmFilter)

                        continuation.resume(returning: ())
                    }
                } catch { }
            }
        }
    }
}
