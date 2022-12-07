class EpisodeDetail {
    let id: String
    let name: String
    let date: Date
    let seasonID: String
    let characters: [CharacterSummary]

    private init(builder: Builder) {
        self.id = builder.id!
        self.name = builder.name!
        self.date = builder.date!
        self.seasonID = builder.seasonID!
        self.characters = builder.characters!
    }

    class Builder {
        fileprivate var id: String? = .none
        fileprivate var name: String? = .none
        fileprivate var date: Date? = .none
        fileprivate var seasonID: String? = .none
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

        func set(seasonID: String) -> Self {
            self.seasonID = seasonID
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

extension EpisodeDetail {
    class Mother {
        static func build(id: String) -> EpisodeDetail {
            EpisodeDetail.Builder()
                .set(id: id)
                .set(seasonID: "S01E\(id)")
                .set(name: "M. Night Shaym-Aliens!")
                .set(date: Date())
                .set(characters: (1...10).map { i in CharacterSummary.Mother.build(id: String(i)) })
                .build()
        }
    }
}
