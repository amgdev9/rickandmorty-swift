import Apollo

class GraphQLCharactersDataSource: CharactersRemoteDataSource {
    let pageSizeMutex = DispatchSemaphore(value: 1)
    var numPages: Int? = .none
    var pageSize = 20

    let apolloClient: ApolloClient

    init(apolloClient: ApolloClient) {
        self.apolloClient = apolloClient
    }

    func getCharacters(page: Int) async -> Result<[CharacterSummary], Error> {
        var cancellable: Cancellable? = .none
        return await withTaskCancellationHandler { [cancellable] in
            cancellable?.cancel()
        } operation: {
            return await withCheckedContinuation { continuation in
                cancellable = apolloClient.fetch(query: CharactersQuery(page: page)) { result in
                    if let error = result.failure() {
                        continuation.resume(returning: .failure(Error(message: error.localizedDescription)))
                        return
                    }

                    let characters = result.unwrap()!.data?.characters?.results
                    guard let characters = characters else {
                        continuation.resume(returning: .failure(Error(message: String(localized: "error/unknown"))))
                        return
                    }

                    guard let pages = result.unwrap()!.data?.characters?.info?.pages else {
                        continuation.resume(returning: .failure(Error(message: String(localized: "error/unknown"))))
                        return
                    }

                    self.setNumPages(numPages: pages)

                    let domainCharacters = characters
                        .compactMap { $0 }
                        .map { $0.toDomain() }
                    continuation.resume(returning: .success(domainCharacters))
                }
            }
        }
    }

    private func setNumPages(numPages: Int) {
        pageSizeMutex.wait()
        self.numPages = numPages
        pageSizeMutex.signal()
    }
}

extension CharactersQuery.Data.Characters.Result {
    private static let toDomainStatus: [String: Character.Status] = [
        "Alive": .alive,
        "Dead": .dead,
        "unknown": .unknown
    ]

    func toDomain() -> CharacterSummary {
        return CharacterSummary.Builder()
            .set(id: id ?? "")
            .set(name: name ?? "")
            .set(imageURL: image ?? "")
            .set(status: CharactersQuery.Data.Characters.Result.toDomainStatus[status ?? "unknown"] ?? .unknown)
            .build()
    }
}
