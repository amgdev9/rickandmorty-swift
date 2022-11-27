class GraphQLCharacterDetailDataSource: CharacterDetailRemoteDataSource {
    let apolloClient: ApolloClient

    init(apolloClient: ApolloClient) {
        self.apolloClient = apolloClient
    }

    func getCharacterDetail(id: String) async -> Result<CharacterDetails, Error> {
        var cancellable: Cancellable? = .none
        return await withTaskCancellationHandler { [cancellable] in
            cancellable?.cancel()
        } operation: {
            return await withCheckedContinuation { continuation in
                cancellable = apolloClient.fetch(query: CharacterDetailQuery(id: id)) { result in
                    guard let result = result.unwrap() else {
                        return continuation.resume(returning: .failure(
                            Error(message: result.failure()!.localizedDescription))
                        )
                    }

                    guard let character = result.data?.character else {
                        return continuation.resume(returning: .failure(Error(message: String(localized: "error/unknown"))))
                    }

                    continuation.resume(returning: .success(character.toDomain()))
                }
            }
        }
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

    func toDomain() -> CharacterDetails {
        let summary = self.fragments.characterSummaryFragment.toDomain()
        return CharacterDetails.Builder()
            .set(id: summary.id)
            .set(name: summary.name)
            .set(imageURL: summary.imageURL)
            .set(status: summary.status)
            .set(species: species ?? "")
            .set(gender: genderToDomain())
            .set(type: type)
            .set(origin: origin?.fragments.characterLocationFragment.toDomain())
            .set(location: location?.fragments.characterLocationFragment.toDomain())
            .set(episodes: episode.compactMap { $0 }.map { $0.fragments.episodeSummaryFragment.toDomain() })
            .build()
    }
}
