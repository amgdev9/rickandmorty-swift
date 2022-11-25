class EpisodeDetail {
    let id: String
    let name: String
    let date: Date
    let characters: [CharacterSummary]

    private init(builder: Builder) {
        self.id = builder.id!
        self.name = builder.name!
        self.date = builder.date!
        self.characters = builder.characters!
    }

    class Builder {
        fileprivate var id: String? = .none
        fileprivate var name: String? = .none
        fileprivate var date: Date? = .none
        fileprivate var characters: [CharacterSummary]? = .none

        func set(id: String) -> Self {
            self.id = id
            return self
        }

        func set(name: String) -> Self {
            self.name = name
            return self
        }

        func set(date: Date) -> Self {
            self.date = date
            return self
        }

        func set(characters: [CharacterSummary]) -> Self {
            self.characters = characters
            return self
        }

        func build() -> EpisodeDetail {
            return EpisodeDetail(builder: self)
        }
    }
}
