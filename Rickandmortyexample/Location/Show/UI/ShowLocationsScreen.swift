import SwiftUI

struct ShowLocationsScreen<ViewModel>: View where ViewModel: ShowLocationsViewModel {
    @StateObject private var viewModel: ViewModel
    let router: ShowLocationsScreenRouter

    @EnvironmentObject var i18n: I18N

    init(router: ShowLocationsScreenRouter, viewModelFactory: @escaping () -> ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModelFactory())
        self.router = router
    }

    var body: some View {
        NavigationContainer(title: i18n.t("routes/location")) {
            LocationList(data: viewModel.listState,
                          onRefetch: viewModel.refetch,
                          onLoadNextPage: viewModel.fetchNextPage,
                          onPress: router.gotoLocationDetail)
        }
        .toolbar {
            FilterButton(showDot: viewModel.hasFilters, action: router.gotoLocationFilters)
        }
        .onMount(perform: viewModel.onViewMount)
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
        func refetch() async {
            await PreviewUtils.delay()
        }
        func fetchNextPage() async {
            await PreviewUtils.delay()
        }
    }

    static var previews: some View {
        NavigationStack {
            ShowLocationsScreen(router: RouterMock()) {
                ViewModelMock()
            }
        }
    }
}
