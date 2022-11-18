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
        fileprivate var id: String?
        fileprivate var imageURL: String?
        fileprivate var name: String?
        fileprivate var status: Character.Status?

        init() {
            id = .none
            imageURL = .none
            name = .none
            status = .none
        }

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
