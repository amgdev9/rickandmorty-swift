class EpisodeDetailsViewModelImpl: EpisodeDetailsViewModel {
    @Published var episode: NetworkData<EpisodeDetail> = .loading

    @Sendable func refetch() async {
        // TODO
    }
}

// MARK: - Protocol
protocol EpisodeDetailsViewModel: ObservableObject {
    var episode: NetworkData<EpisodeDetail> { get }

    @Sendable func refetch() async
}
