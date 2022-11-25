class FilterEpisodesViewModelImpl: FilterEpisodesViewModel {
    @Published var filter: EpisodeFilter

    init() {
        self.filter = EpisodeFilter()
    }

    func onPressApply(goBack: () -> Void) {
        // TODO
        goBack()
    }

    func onPressClear() {
        // TODO
    }
}

// MARK: - Protocol
protocol FilterEpisodesViewModel: ObservableObject {
    var filter: EpisodeFilter { get set }

    func onPressApply(goBack: () -> Void)
    func onPressClear()
}
