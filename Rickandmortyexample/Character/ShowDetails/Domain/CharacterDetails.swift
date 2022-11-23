class CharacterDetails {
    let id: String
    let imageURL: String
    let name: String
    let status: Character.Status
    let gender: Character.Gender
    let species: String
    let type: String?
    let origin: CharacterLocation
    let location: CharacterLocation
    let episodes: [EpisodeSummary]

    private init(builder: Builder) {
        self.id = builder.id!
        self.name = builder.name!
        self.imageURL = builder.imageURL!
        self.status = builder.status!
        self.gender = builder.gender!
        self.species = builder.species!
        self.type = builder.type
        self.origin = builder.origin!
        self.location = builder.location!
        self.episodes = builder.episodes!
    }

    class Builder {
        fileprivate var id: String? = .none
        fileprivate var imageURL: String? = .none
        fileprivate var name: String? = .none
        fileprivate var status: Character.Status? = .none
        fileprivate var gender: Character.Gender? = .none
        fileprivate var species: String? = .none
        fileprivate var type: String? = .none
        fileprivate var origin: CharacterLocation? = .none
        fileprivate var location: CharacterLocation? = .none
        fileprivate var episodes: [EpisodeSummary]? = .none
        
        func set(id: String) -> Self {
            self.id = id
            return self
        }

        func set(imageURL: String) -> Self {
            self.imageURL = imageURL
            return self
        }

        func set(name: String) -> Self {
            self.name = name
            return self
        }

        func set(status: Character.Status) -> Self {
            self.status = status
            return self
        }

        func set(gender: Character.Gender) -> Self {
            self.gender = gender
            return self
        }

        func set(species: String) -> Self {
            self.species = species
            return self
        }

        func set(type: String?) -> Self {
            self.type = type
            return self
        }

        func set(origin: CharacterLocation) -> Self {
            self.origin = origin
            return self
        }

        func set(location: CharacterLocation) -> Self {
            self.location = origin
            return self
        }

        func set(episodes: [EpisodeSummary]) -> Self {
            self.episodes = episodes
            return self
        }

        func build() -> CharacterDetails {
            return CharacterDetails(builder: self)
        }
    }
}
