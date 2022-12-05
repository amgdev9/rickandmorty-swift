import RealmSwift

class RealmCharacterFilter: RealmSwift.Object {
    @Persisted(primaryKey: true) var primaryId: String
    @Persisted var name: String
    @Persisted var species: String
    @Persisted var status: Int8
    @Persisted var gender: Int8
    @Persisted var createdAt: Date

    @Persisted(originProperty: "filter") var list: LinkingObjects<RealmCharacterList>

    static private let schemaId = "character-filter-"

    static func primaryId(id: String) -> String {
        return "\(schemaId)\(id)"
    }

    convenience init(filter: CharacterFilter) {
        self.init()
        name = filter.name
        species = filter.species
        status = mapFromDomain(status: filter.status)
        gender = mapFromDomain(gender: filter.gender)
        primaryId = "\(Self.schemaId)\(name)-\(species)-\(status)-\(gender)"
        createdAt = Date()
    }

    func delete(realm: Realm) {
        list.forEach { $0.delete(realm: realm) }
        realm.delete(self)
    }

    private func mapFromDomain(status: Character.Status?) -> Int8 {
        guard let status = status else { return -1 }
        switch status {
        case .alive: return 0
        case .dead: return 1
        case .unknown: return 2
        }
    }

    private func mapFromDomain(gender: Character.Gender?) -> Int8 {
        guard let gender = gender else { return -1 }
        switch gender {
        case .male: return 0
        case .female: return 1
        case .unknown: return 2
        case .genderless: return 3
        }
    }

    private func mapStatusToDomain(status: Int8) -> Character.Status? {
        switch status {
        case 0: return .alive
        case 1: return .dead
        case 2: return .unknown
        default: return .none
        }
    }

    private func mapGenderToDomain(gender: Int8) -> Character.Gender? {
        switch gender {
        case 0: return .male
        case 1: return .female
        case 2: return .unknown
        case 3: return .genderless
        default: return .none
        }
    }

    func toDomain() -> CharacterFilter {
        return CharacterFilter(name: name, species: species, status: mapStatusToDomain(status: status), gender: mapGenderToDomain(gender: gender))
    }
}
