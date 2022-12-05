import SwiftUI

struct ShowLocationsScreen<ViewModel>: View where ViewModel: ShowLocationsViewModel {
    @StateObject private var viewModel: ViewModel
    let router: ShowLocationsScreenRouter

    init(router: ShowLocationsScreenRouter, viewModelFactory: @escaping () -> ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModelFactory())
        self.router = router
    }

    var body: some View {
        NavigationContainer(title: String(localized: "routes/location")) {
            LocationList(data: viewModel.listState,
                          onRefetch: viewModel.refetch,
                          onLoadNextPage: viewModel.loadNextPage,
                          onPress: router.gotoLocationDetail)
        }
        .toolbar {
            FilterButton(showDot: viewModel.hasFilters, action: router.gotoLocationFilters)
        }
        .onAppear(perform: viewModel.onViewMount)
        .errorAlert($viewModel.error)
    }
}

// MARK: - Types
protocol ShowLocationsScreenRouter {
    func gotoLocationFilters()
    func gotoLocationDetail(id: String)
}

// MARK: - Previews
struct ShowLocationsScreenPreviews: PreviewProvider {
    class RouterMock: ShowLocationsScreenRouter {
        func gotoLocationFilters() {}
        func gotoLocationDetail(id: String) {}
    }

    class ViewModelMock: ShowLocationsViewModel {
        var listState = NetworkData.data(PaginatedResponse(items: (1...10).map { i in
            LocationSummary.Mother.build(id: String(i))
        }, hasNext: false))
        var hasFilters = true
        var error: Error? = .none

        func onViewMount() {}
        func refetch() async {}
        func loadNextPage() async {}
    }

    static var previews: some View {
        NavigationStack {
            ShowLocationsScreen(router: RouterMock()) {
                ViewModelMock()
            }
        }
    }
}
