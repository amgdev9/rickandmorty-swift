class FilterLocationsViewModelImpl: FilterLocationsViewModel {
    @Published var filter = LocationFilter()

    let locationFilterRepository: LocationFilterRepository

    init(locationFilterRepository: LocationFilterRepository) {
        self.locationFilterRepository = locationFilterRepository
    }

    func onViewMount() {
        Task {
            let latestFilter = await locationFilterRepository.getLatestFilter()

            await MainActor.run {
                self.filter = latestFilter
            }
        }
    }

    func onPressApply(goBack: @escaping () -> Void) {
        Task {
            await locationFilterRepository.addFilter(filter: filter)
            await MainActor.run {
                goBack()
            }
        }
    }

    func onPressClear() {
        filter = LocationFilter()
    }
}

// MARK: - Protocol
protocol FilterLocationsViewModel: ObservableObject {
    var filter: LocationFilter { get set }

    func onViewMount()
    func onPressApply(goBack: @escaping () -> Void)
    func onPressClear()
}
