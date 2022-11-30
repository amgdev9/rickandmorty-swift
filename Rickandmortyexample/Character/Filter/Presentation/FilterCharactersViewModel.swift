class FilterCharactersViewModelImpl: FilterCharactersViewModel {
    @Published var filter: CharacterFilter

    init() {
        self.filter = CharacterFilter()
    }

    func onPressApply(goBack: () -> Void) {
        // TODO
        goBack()
    }

    func onPressClear() {
        filter = CharacterFilter()
    }
}

// MARK: - Protocol
protocol FilterCharactersViewModel: ObservableObject {
    var filter: CharacterFilter { get set }

    func onPressApply(goBack: () -> Void)
    func onPressClear()
}
