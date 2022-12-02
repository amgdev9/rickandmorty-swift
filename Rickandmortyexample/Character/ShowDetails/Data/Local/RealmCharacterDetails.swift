import RealmSwift

class RealmCharacterDetails: RealmSwift.Object {
    @Persisted(primaryKey: true) var primaryId: String
    @Persisted var gender: Int8
    @Persisted var species: String
    @Persisted var type: String?

    @Persisted var origin: RealmLocationSummary?
    @Persisted var location: RealmLocationSummary?
    @Persisted var episodes: List<RealmEpisodeSummary>
    @Persisted(originProperty: "detail") var summary: LinkingObjects<RealmCharacterSummary>

    static private let schemaId = "character-details-"

    static func primaryId(id: String) -> String {
        return "\(schemaId)\(id)"
    }

    convenience init(detail: CharacterDetails) {
        self.init()
        self.primaryId = "\(Self.schemaId)\(detail.id)"
        self.species = detail.species
        self.gender = mapFromDomain(gender: detail.gender)
        self.type = detail.type
    }

    func delete(realm: Realm) {
        origin?.delete(realm: realm)
        location?.delete(realm: realm)
        episodes.forEach { $0.delete(realm: realm) }
        realm.delete(self)
    }

    private func mapFromDomain(gender: Character.Gender) -> Int8 {
        switch gender {
        case .male: return 1
        case .female: return 2
        case .genderless: return 3
        case .unknown: return 4
        }
    }

    private func mapGenderToDomain(gender: Int8) -> Character.Gender {
        switch gender {
        case 1: return .male
        case 2: return .female
        case 3: return .genderless
        default: return .unknown
        }
    }

    func toDomain() -> CharacterDetails {
        let summary = summary.first!.toDomain()
        return CharacterDetails.Builder()
            .set(id: summary.id)
            .set(name: summary.name)
            .set(imageURL: summary.imageURL)
            .set(status: summary.status)
            .set(species: species)
            .set(gender: mapGenderToDomain(gender: gender))
            .set(type: type)
            .set(origin: origin?.toCharacterLocation())
            .set(location: location?.toCharacterLocation())
            .set(episodes: episodes.map { $0.toDomain() })
            .build()
    }
}
