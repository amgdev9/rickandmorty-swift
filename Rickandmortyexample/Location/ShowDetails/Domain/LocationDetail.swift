class LocationDetail {
    let id: String
    let name: String
    let type: String
    let dimension: String
    let residents: [CharacterSummary]

    private init(builder: Builder) {
        self.id = builder.id!
        self.name = builder.name!
        self.type = builder.type!
        self.dimension = builder.dimension!
        self.residents = builder.residents!
    }

    class Builder {
        fileprivate var id: String? = .none
        fileprivate var name: String? = .none
        fileprivate var type: String? = .none
        fileprivate var dimension: String? = .none
        fileprivate var residents: [CharacterSummary]? = .none

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

        func set(dimension: String) -> Self {
            self.dimension = dimension
            return self
        }

        func set(residents: [CharacterSummary]) -> Self {
            self.residents = residents
            return self
        }

        func build() -> LocationDetail {
            return LocationDetail(builder: self)
        }
    }
}

extension LocationDetail {
    class Mother {
        static func build(id: String) -> LocationDetail {
            LocationDetail.Builder()
                .set(id: id)
                .set(name: "Earth (Replacement Dimension)")
                .set(type: "Planet")
                .set(dimension: "Replacement Dimension")
                .set(residents: (1...10).map { i in
                    CharacterSummary.Mother.build(id: String(i))
                })
                .build()
        }
    }
}
