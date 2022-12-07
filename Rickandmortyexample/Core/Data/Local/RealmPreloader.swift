class RealmPreloader {
    let realmFactory: RealmFactory

    init(realmFactory: RealmFactory) {
        self.realmFactory = realmFactory
    }

    func preload() {
        do {
            let realm = try realmFactory.buildWithoutQueue()
            try RealmCharacterFilterRepository.preload(realm: realm)
            try RealmLocationFilterRepository.preload(realm: realm)
            try RealmEpisodeFilterRepository.preload(realm: realm)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
