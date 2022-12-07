import RealmSwift

class RealmEpisodesDataSource: EpisodesLocalDataSource {
    let realmFactory: RealmFactory
    let realmQueue: DispatchQueue

    private let maxEpisodesPerList = 60

    init(realmFactory: RealmFactory, realmQueue: DispatchQueue) {
        self.realmFactory = realmFactory
        self.realmQueue = realmQueue
    }

    func getEpisodes(filter: EpisodeFilter) async -> [EpisodeSummary]? {
        return await withCheckedContinuation { continuation in
            realmQueue.async {
                do {
                    let realm = try self.realmFactory.build()

                    let realmFilter = RealmEpisodeFilter(filter: filter)
                    let list = realm.objects(RealmEpisodeList.self)
                        .where { $0.filter.primaryId.equals(realmFilter.primaryId) }

                    guard let list = list.first else { return continuation.resume(returning: .none) }

                    var domainEpisodes: [EpisodeSummary] = []
                    list.episodes.forEach {
                        domainEpisodes.append($0.toDomain())
                    }

                    return continuation.resume(returning: domainEpisodes)
                } catch {
                    return continuation.resume(returning: .none)
                }
            }
        }
    }

    func insertEpisodes(episodes: [EpisodeSummary], filter: EpisodeFilter) async {
        return await withCheckedContinuation { continuation in
            realmQueue.async {
                defer {
                    continuation.resume(returning: ())
                }

                do {
                    let realm = try self.realmFactory.build()

                    let filterId = RealmEpisodeFilter(filter: filter).primaryId
                    let realmFilter = realm.objects(RealmEpisodeFilter.self)
                        .where { $0.primaryId.equals(filterId) }
                    guard let realmFilter = realmFilter.first else { return continuation.resume(returning: ()) }

                    let list = realm.objects(RealmEpisodeList.self)
                        .where { $0.filter.primaryId.equals(realmFilter.primaryId) }

                    if let list = list.first {
                        try realm.write {
                            let numDiscardedEpisodes = max(
                                list.episodes.count + episodes.count - self.maxEpisodesPerList,
                                0
                            )
                            let realmEpisodes = episodes
                                .dropLast(numDiscardedEpisodes)
                                .map { RealmEpisodeSummary(episodeSummary: $0) }

                            realmEpisodes.forEach {
                                realm.add($0, update: .modified)
                            }

                            list.episodes.append(objectsIn: realmEpisodes)
                        }
                    } else {
                        try realm.write {
                            self.createNewList(with: episodes, realm: realm, filter: realmFilter)
                        }
                    }
                } catch {}
            }
        }
    }

    private func createNewList(with episodes: [EpisodeSummary], realm: Realm, filter: RealmEpisodeFilter) {
        let list = RealmEpisodeList(filter: filter)

        let numDiscardedEpisodes = max(episodes.count - self.maxEpisodesPerList, 0)
        let realmEpisodes = episodes.dropLast(numDiscardedEpisodes).map { RealmEpisodeSummary(episodeSummary: $0) }

        realmEpisodes.forEach {
            realm.add($0, update: .modified)
        }
        list.episodes.append(objectsIn: realmEpisodes)

        realm.add(list)
    }

    func setEpisodes(episodes: [EpisodeSummary], filter: EpisodeFilter) async {
        return await withCheckedContinuation { continuation in
            realmQueue.async {
                defer {
                    continuation.resume(returning: ())
                }

                do {
                    let realm = try self.realmFactory.build()

                    let filterId = RealmEpisodeFilter(filter: filter).primaryId
                    let realmFilter = realm.objects(RealmEpisodeFilter.self)
                        .where { $0.primaryId.equals(filterId) }
                    guard let realmFilter = realmFilter.first else { return continuation.resume(returning: ()) }

                    let list = realm.objects(RealmEpisodeList.self)
                        .where { $0.filter.primaryId.equals(realmFilter.primaryId) }
                        .first

                    try realm.write {
                        if let list = list {
                            list.delete(realm: realm)
                        }

                        self.createNewList(with: episodes, realm: realm, filter: realmFilter)
                    }
                } catch {}
            }
        }
    }
}
