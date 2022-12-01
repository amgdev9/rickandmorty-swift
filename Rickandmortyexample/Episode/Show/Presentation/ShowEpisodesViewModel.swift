class ShowEpisodesViewModelImpl: ShowEpisodesViewModel {
    @Published var seasons: NetworkData<PaginatedResponse<EpisodeSeason>> = .loading
    @Published var hasFilters = false
    @Published var error: Error? = .none

    func onViewMount() {
        // TODO
    }

    @Sendable func refetch() async {
        // TODO
    }

    func loadNextPage() async {
        // TODO
    }
}

// MARK: - Protocol
protocol ShowEpisodesViewModel: ObservableObject {
    var seasons: NetworkData<PaginatedResponse<EpisodeSeason>> { get }
    var hasFilters: Bool { get }
    var error: Error? { get set }

    func onViewMount()
    @Sendable func refetch() async
    func loadNextPage() async
}
