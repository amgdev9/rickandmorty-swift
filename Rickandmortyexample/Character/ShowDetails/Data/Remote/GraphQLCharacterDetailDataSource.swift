class GraphQLCharacterDetailDataSource: CharacterDetailRemoteDataSource {
    let apolloClient: ApolloClient

    init(apolloClient: ApolloClient) {
        self.apolloClient = apolloClient
    }

    func getCharacterDetail(id: String) async -> Result<CharacterDetails, Error> {
        let result = await apolloClient.fetchAsync(query: CharacterDetailQuery(id: id))

        guard let result = result.unwrap() else {
            return .failure(Error(message: result.failure()!.localizedDescription))
        }

        guard let character = result.data?.character else {
            return .failure(Error(message: String(localized: "error/unknown")))
        }

        return .success(character.toDomain())
    }
}

extension CharacterDetailQuery.Data.Character {
    func genderToDomain() -> Character.Gender {
        switch gender {
        case "Male": return .male
        case "Female": return .female
        case "Genderless": return .genderless
        default: return .unknown
        }
    }

    func typeToDomain() -> String? {
        guard let type = type else { return .none }
        if type.isEmpty { return .none }
        return type
    }

    func toDomain() -> CharacterDetails {
        let summary = self.fragments.characterSummaryFragment.toDomain()

        return CharacterDetails.Builder()
            .set(id: summary.id)
            .set(name: summary.name)
            .set(imageURL: summary.imageURL)
            .set(status: summary.status)
            .set(species: species ?? "")
            .set(gender: genderToDomain())
            .set(type: typeToDomain())
            .set(origin: origin?.fragments.characterLocationFragment.toDomain())
            .set(location: location?.fragments.characterLocationFragment.toDomain())
            .set(episodes: episode.compactMap { $0 }.map { $0.fragments.episodeSummaryFragment.toDomain() })
            .build()
    }
}
