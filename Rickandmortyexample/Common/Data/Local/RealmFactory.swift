import RealmSwift

class RealmFactory {
    let configuration: Realm.Configuration
    let serialQueue: DispatchQueue
    let mainRealm: Realm? // We need to keep at least one reference so in memory database does not get invalidated

    init(serialQueue: DispatchQueue, schemaVersion: UInt64) {
        self.configuration = Realm.Configuration(inMemoryIdentifier: "realm-db", schemaVersion: schemaVersion)
        self.serialQueue = serialQueue
        do {
            mainRealm = try Realm(configuration: configuration)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func build() throws -> Realm {
        return try Realm(configuration: configuration, queue: serialQueue)
    }

    func buildWithoutQueue() throws -> Realm {
        return try Realm(configuration: configuration)
    }
}
