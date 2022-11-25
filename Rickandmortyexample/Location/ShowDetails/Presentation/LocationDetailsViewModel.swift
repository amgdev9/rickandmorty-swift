class LocationDetailsViewModelImpl: LocationDetailsViewModel {
    @Published var location: NetworkData<LocationDetail> = .loading

    @Sendable func refetch() async {
        // TODO
    }
}

// MARK: - Protocol
protocol LocationDetailsViewModel: ObservableObject {
    var location: NetworkData<LocationDetail> { get }

    @Sendable func refetch() async
}
