import Apollo

class GraphQLCharactersDataSource: CharactersRemoteDataSource {
    var pageSize: UInt32 = 20

    let apolloClient: ApolloClient

    init(apolloClient: ApolloClient) {
        self.apolloClient = apolloClient
    }

    func getCharacters(
        page: UInt32,
        filter: CharacterFilter
    ) async -> Result<PaginatedResponse<CharacterSummary>, Error> {
        print("GQL.getCharacters \(page)")
        let result = await apolloClient.fetchAsync(
            query: CharactersQuery(page: Int(page), filter: FilterCharacter.from(filter: filter))
        )
        guard let result = result.unwrap() else {
            return .failure(Error(message: result.failure()!.localizedDescription))
        }

        guard let characters = result.data?.characters?.results else {
            return .failure(Error(message: String(localized: "error/unknown")))
        }

        guard let info = result.data?.characters?.info else {
            return .failure(Error(message: String(localized: "error/unknown")))
        }

        let domainCharacters = characters
            .compactMap { $0 }
            .map { $0.fragments.characterSummaryFragment.toDomain() }

        return .success(PaginatedResponse(items: domainCharacters, hasNext: info.next != nil))
    }
}

extension FilterCharacter {
    static func mapGender(_ gender: Character.Gender?) -> GraphQLNullable<String> {
        guard let gender = gender else { return .none }

        switch gender {
        case .male: return "Male"
        case .female: return "Female"
        case .genderless: return "Genderless"
        case .unknown: return "unknown"
        }
    }

    static func mapStatus(_ status: Character.Status?) -> GraphQLNullable<String> {
        guard let status = status else { return .none }

        switch status {
        case .alive: return "Alive"
        case .dead: return "Dead"
        case .unknown: return "unknown"
        }
    }

    static func mapString(_ value: String) -> GraphQLNullable<String> {
        if value.isEmpty { return .none }
        return .some(value)
    }

    static func from(filter: CharacterFilter) -> Self {
        return FilterCharacter(
            name: mapString(filter.name),
            status: mapStatus(filter.status),
            species: mapString(filter.species),
            gender: mapGender(filter.gender)
        )
    }
}
