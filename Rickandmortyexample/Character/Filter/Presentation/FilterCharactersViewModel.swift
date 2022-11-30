class FilterCharactersViewModelImpl: FilterCharactersViewModel {
    @Published var filter: CharacterFilter

    let characterFilterRepository: CharacterFilterRepository

    init(characterFilterRepository: CharacterFilterRepository) {
        self.filter = CharacterFilter()
        self.characterFilterRepository = characterFilterRepository
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

    func onPressApply(goBack: @escaping () -> Void)
    func onPressClear()
}
