import RealmSwift

class RealmLocationsDataSource: LocationsLocalDataSource {
    let realmFactory: RealmFactory
    let realmQueue: DispatchQueue

    private let maxLocationsPerList = 60

    init(realmFactory: RealmFactory, realmQueue: DispatchQueue) {
        self.realmFactory = realmFactory
        self.realmQueue = realmQueue
    }

    func getLocations(filter: LocationFilter) async -> [LocationSummary]? {
        return await realmQueue.runAsync { continuation in
            do {
                let realm = try self.realmFactory.build()

                let realmFilter = RealmLocationFilter(filter: filter)
                let list = realm.objects(RealmLocationList.self)
                    .where { $0.filter.primaryId.equals(realmFilter.primaryId) }

                guard let list = list.first else { return continuation.resume(returning: .none) }

                var domainLocations: [LocationSummary] = []
                list.locations.forEach {
                    // As we get them from the locations list, we should be able to map it to a LocationSummary
                    domainLocations.append($0.toLocationSummary()!)
                }

                return continuation.resume(returning: domainLocations)
            } catch {
                return continuation.resume(returning: .none)
            }
        }
    }

    func insertLocations(locations: [LocationSummary], filter: LocationFilter) async {
        return await realmQueue.runAsync { continuation in
            defer {
                continuation.resume(returning: ())
            }

            do {
                let realm = try self.realmFactory.build()

                let filterId = RealmLocationFilter(filter: filter).primaryId
                let realmFilter = realm.objects(RealmLocationFilter.self)
                    .where { $0.primaryId.equals(filterId) }
                guard let realmFilter = realmFilter.first else { return }

                let list = realm.objects(RealmLocationList.self)
                    .where { $0.filter.primaryId.equals(realmFilter.primaryId) }

                if let list = list.first {
                    try realm.write {
                        let numDiscardedLocations = max(
                            list.locations.count + locations.count - self.maxLocationsPerList,
                            0
                        )
                        let realmLocations = locations
                            .dropLast(numDiscardedLocations)
                            .map { RealmLocationSummary(locationSummary: $0) }

                        realmLocations.forEach {
                            realm.add($0, update: .modified)
                        }

                        list.locations.append(objectsIn: realmLocations)
                    }
                } else {
                    try realm.write {
                        self.createNewList(with: locations, realm: realm, filter: realmFilter)
                    }
                }
            } catch {}
        }
    }

    private func createNewList(with locations: [LocationSummary], realm: Realm, filter: RealmLocationFilter) {
        let list = RealmLocationList(filter: filter)

        let numDiscardedLocations = max(locations.count - self.maxLocationsPerList, 0)
        let realmLocations = locations.dropLast(numDiscardedLocations).map { RealmLocationSummary(locationSummary: $0) }

        realmLocations.forEach {
            realm.add($0, update: .modified)
        }
        list.locations.append(objectsIn: realmLocations)

        realm.add(list)
    }

    func setLocations(locations: [LocationSummary], filter: LocationFilter) async {
        return await realmQueue.runAsync { continuation in
            defer {
                continuation.resume(returning: ())
            }

            do {
                let realm = try self.realmFactory.build()

                let filterId = RealmLocationFilter(filter: filter).primaryId
                let realmFilter = realm.objects(RealmLocationFilter.self)
                    .where { $0.primaryId.equals(filterId) }
                guard let realmFilter = realmFilter.first else { return continuation.resume(returning: ()) }

                let list = realm.objects(RealmLocationList.self)
                    .where { $0.filter.primaryId.equals(realmFilter.primaryId) }
                    .first

                try realm.write {
                    if let list = list {
                        list.delete(realm: realm)
                    }

                    self.createNewList(with: locations, realm: realm, filter: realmFilter)
                }
            } catch {}
        }
    }
}
