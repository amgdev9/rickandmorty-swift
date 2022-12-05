import NeedleFoundation

class RealmComponent: Component<EmptyDependency> {
    var realmFactory: RealmFactory {
        return shared {
            RealmFactory(serialQueue: realmQueue, schemaVersion: 1)
        }
    }

    var realmQueue: DispatchQueue {
        return shared {
            DispatchQueue(label: "realm-queue")
        }
    }

    var realmPreloader: RealmPreloader {
        return RealmPreloader(realmFactory: realmFactory)
    }
}
