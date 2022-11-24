class ShowLocationsViewModelImpl: ShowLocationsViewModel {
    @Published var listState: NetworkData<[LocationSummary]> = .loading
    @Published var hasFilters: Bool = false
    @Published var error: Error? = .none

    func onViewMount() {
        // TODO
    }

    func refetch() async {
        // TODO
    }

    func loadNextPage() async {
        // TODO
    }
}

// MARK: - Protocol
protocol ShowLocationsViewModel: ObservableObject {
    var listState: NetworkData<[LocationSummary]> { get }
    var hasFilters: Bool { get }
    var error: Error? { get set }

    func onViewMount()
    @Sendable func refetch() async
    func loadNextPage() async
}
