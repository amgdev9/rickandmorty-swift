class FilterEpisodesViewModelImpl: FilterEpisodesViewModel {
    @Published var filter = EpisodeFilter()

    let episodeFilterRepository: EpisodeFilterRepository

    init(episodeFilterRepository: EpisodeFilterRepository) {
        self.episodeFilterRepository = episodeFilterRepository
    }

    func onViewMount() {
        Task {
            let latestFilter = await episodeFilterRepository.getLatestFilter()

            await MainActor.run {
                self.filter = latestFilter
            }
        }
    }

    func onPressApply(goBack: @escaping () -> Void) {
        Task {
            await episodeFilterRepository.addFilter(filter: filter)
            await MainActor.run {
                goBack()
            }
        }
    }

    func onPressClear() {
        filter = EpisodeFilter()
    }
}

// MARK: - Protocol
protocol FilterEpisodesViewModel: ObservableObject {
    var filter: EpisodeFilter { get set }

    func onViewMount()
    func onPressApply(goBack: @escaping () -> Void)
    func onPressClear()
}
