class CharacterDetailsViewModelImpl: CharacterDetailsViewModel {
    @Published var character: NetworkData<CharacterDetails> = .loading

    @Sendable func refetch() async {
        // TODO
    }
}

// MARK: - Protocol
protocol CharacterDetailsViewModel: ObservableObject {
    var character: NetworkData<CharacterDetails> { get }

    @Sendable func refetch() async
}
