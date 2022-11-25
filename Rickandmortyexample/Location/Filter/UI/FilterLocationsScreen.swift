import SwiftUI

// MARK: - View
struct FilterLocationsScreen<ViewModel>: View where ViewModel: FilterLocationsViewModel {
    @StateObject private var viewModel: ViewModel
    let router: FilterLocationsScreenRouter

    init(router: FilterLocationsScreenRouter, viewModelFactory: @escaping () -> ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModelFactory())
        self.router = router
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                FilterHeader(onPressApply: { viewModel.onPressApply(goBack: router.goBack)
                }, onPressClear: viewModel.onPressClear, clearDisabled: viewModel.filter.isEmpty)
                .padding(.bottom, 26.5)
                .padding(.top, 18)
                SectionButton(
                    title: String(localized: "section/name-title"),
                    subtitle: String(localized: "section/name-subtitle"),
                    active: !viewModel.filter.name.isEmpty) {
                        router.goSearch()
                    }.padding(.bottom, 19)
                SectionButton(
                    title: String(localized: "section/type"),
                    subtitle: String(localized: "action/select-one"),
                    active: !viewModel.filter.type.isEmpty) {
                        router.goSearch()
                    }.padding(.bottom, 19)
                SectionButton(
                    title: String(localized: "section/dimension"),
                    subtitle: String(localized: "action/select-one"),
                    active: !viewModel.filter.dimension.isEmpty) {
                        router.goSearch()
                    }.padding(.bottom, 19)
            }
        }
        .presentationDetents([.fraction(1), .large])
    }
}

// MARK: - Types
protocol FilterLocationsScreenRouter {
    func goBack()
    func goSearch() // TODO
}

// MARK: - Previews
struct FilterLocationsScreenPreviews: PreviewProvider {
    class RouterMock: FilterLocationsScreenRouter {
        func goSearch() {}
        func goBack() {}
    }

    class ViewModelMock: FilterLocationsViewModel {
        var filter = LocationFilter()

        func onPressApply(goBack: () -> Void) {}
        func onPressClear() {}
    }

    static var previews: some View {
        NavigationStack {}
        .sheet(isPresented: .init(get: { true }, set: {_ in })) {
            FilterLocationsScreen(router: RouterMock()) {
                ViewModelMock()
            }
        }
    }
}
