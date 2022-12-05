class CharacterSummary {
    let id: String
    let imageURL: String
    let name: String
    let status: Character.Status

    private init(builder: Builder) {
        self.id = builder.id!
        self.name = builder.name!
        self.imageURL = builder.imageURL!
        self.status = builder.status!
    }

    class Builder {
        fileprivate var id: String? = .none
        fileprivate var imageURL: String? = .none
        fileprivate var name: String? = .none
        fileprivate var status: Character.Status? = .none

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

        func build() -> CharacterSummary {
            return CharacterSummary(builder: self)
        }
    }
}

extension CharacterSummary {
    class Mother {
        static func build(id: String) -> CharacterSummary {
            return CharacterSummary.Builder()
                .set(id: id)
                .set(name: "Rick Sanchez")
                .set(imageURL: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
                .set(status: .alive)
                .build()
        }
    }
}
