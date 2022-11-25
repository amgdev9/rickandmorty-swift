class FilterLocationsViewModelImpl: FilterLocationsViewModel {
    @Published var filter: LocationFilter

    init() {
        self.filter = LocationFilter()
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
protocol FilterLocationsViewModel: ObservableObject {
    var filter: LocationFilter { get set }

    func onPressApply(goBack: () -> Void)
    func onPressClear()
}
