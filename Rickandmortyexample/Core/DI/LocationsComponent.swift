import NeedleFoundation

protocol LocationsDependencies: Dependency {

}

class LocationsComponent: Component<LocationsDependencies> {
    var showLocationsViewModel: some ShowLocationsViewModel {
        return ShowLocationsViewModelImpl()
    }

    var locationDetailsViewModel: some LocationDetailsViewModel {
        return LocationDetailsViewModelImpl()
    }

    var filterLocationsViewModel: some FilterLocationsViewModel {
        return FilterLocationsViewModelImpl()
    }
}
