class GraphQLEpisodeDetailDataSource: EpisodeDetailRemoteDataSource {
    let apolloClient: ApolloClient

    init(apolloClient: ApolloClient) {
        self.apolloClient = apolloClient
    }

    func getEpisodeDetail(id: String) async -> Result<EpisodeDetail, Error> {
        var cancellable: Cancellable? = .none
        return await withTaskCancellationHandler { [cancellable] in
            cancellable?.cancel()
        } operation: {
            return await withCheckedContinuation { continuation in
                cancellable = apolloClient.fetch(query: EpisodeDetailQuery(id: id)) { result in
                    guard let result = result.unwrap() else {
                        return continuation.resume(returning: .failure(
                            Error(message: result.failure()!.localizedDescription))
                        )
                    }

                    guard let episode = result.data?.episode else {
                        return continuation.resume(returning: .failure(Error(message: String(localized: "error/unknown"))))
                    }

                    continuation.resume(returning: .success(episode.toDomain()))
                }
            }
        }
    }
}

extension EpisodeDetailQuery.Data.Episode {
    func toDomain() -> EpisodeDetail {
        let summary = fragments.episodeSummaryFragment.toDomain()
        return EpisodeDetail.Builder()
            .set(id: summary.id)
            .set(name: summary.name)
            .set(date: summary.date)
            .set(characters: characters.compactMap{ $0 }.map { $0.fragments.characterSummaryFragment.toDomain() })
            .build()
    }
}
