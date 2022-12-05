class FilterCharactersViewModelImpl: FilterCharactersViewModel {
    @Published var filter = CharacterFilter()

    let characterFilterRepository: CharacterFilterRepository

    init(characterFilterRepository: CharacterFilterRepository) {
        self.characterFilterRepository = characterFilterRepository
    }

    func onViewMount() {
        Task {
            let latestFilter = await characterFilterRepository.getLatestFilter()

            await MainActor.run {
                self.filter = latestFilter
            }
        }
    }

    func onPressApply(goBack: @escaping () -> Void) {
        Task {
            await characterFilterRepository.addFilter(filter: filter)
            await MainActor.run {
                goBack()
            }
        }
    }

    func onPressClear() {
        filter = CharacterFilter()
    }
}

// MARK: - Protocol
protocol FilterCharactersViewModel: ObservableObject {
    var filter: CharacterFilter { get set }

    func onViewMount()
    func onPressApply(goBack: @escaping () -> Void)
    func onPressClear()
}
