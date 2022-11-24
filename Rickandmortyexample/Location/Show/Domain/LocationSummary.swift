class LocationSummary {
    let id: String
    let name: String
    let type: String

    private init(builder: Builder) {
        self.id = builder.id!
        self.name = builder.name!
        self.type = builder.type!
    }

    class Builder {
        fileprivate var id: String? = .none
        fileprivate var name: String? = .none
        fileprivate var type: String? = .none

        func set(id: String) -> Self {
            self.id = id
            return self
        }

        func set(name: String) -> Self {
            self.name = name
            return self
        }

        func set(type: String) -> Self {
            self.type = type
            return self
        }

        func build() -> LocationSummary {
            return LocationSummary(builder: self)
        }
    }
}
