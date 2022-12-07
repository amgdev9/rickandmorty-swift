import SwiftUI

// MARK: - View
struct FilterLocationsScreen<ViewModel>: View where ViewModel: FilterLocationsViewModel {
    @StateObject private var viewModel: ViewModel
    let router: FilterLocationsScreenRouter

    @EnvironmentObject var i18n: I18N

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
                    title: i18n.t("section/name-title"),
                    subtitle: i18n.t("section/name-subtitle"),
                    active: !viewModel.filter.name.isEmpty) {
                        router.goSearchByName(initialValue: viewModel.filter.name)
                    }.padding(.bottom, 19)
                SectionButton(
                    title: i18n.t("section/type"),
                    subtitle: i18n.t("action/select-one"),
                    active: !viewModel.filter.type.isEmpty) {
                        router.goSearchByType(initialValue: viewModel.filter.type)
                    }.padding(.bottom, 19)
                SectionButton(
                    title: i18n.t("section/dimension"),
                    subtitle: i18n.t("action/select-one"),
                    active: !viewModel.filter.dimension.isEmpty) {
                        router.goSearchByDimension(initialValue: viewModel.filter.dimension)
                    }.padding(.bottom, 19)
            }
        }
        .presentationDetents([.fraction(1), .large])
        .onMount(perform: viewModel.onViewMount)
        .onChange(of: router.params, perform: { params in
            if let name = params.name {
                ($viewModel.filter.name).wrappedValue = name
            }
            if let type = params.type {
                ($viewModel.filter.type).wrappedValue = type
            }
            if let dimension = params.dimension {
                ($viewModel.filter.dimension).wrappedValue = dimension
            }
        })
    }
}

// MARK: - Types
protocol FilterLocationsScreenRouter {
    var params: FilterLocationsScreenParams { get }

    func goBack()
    func goSearchByName(initialValue: String)
    func goSearchByType(initialValue: String)
    func goSearchByDimension(initialValue: String)
}

struct FilterLocationsScreenParams: Hashable {
    let name: String?
    let type: String?
    let dimension: String?
}

// MARK: - Previews
struct FilterLocationsScreenPreviews: PreviewProvider {
    class RouterMock: FilterLocationsScreenRouter {
        var params = FilterLocationsScreenParams(name: .none, type: .none, dimension: .none)
        func goSearchByName(initialValue: String) {}
        func goSearchByType(initialValue: String) {}
        func goSearchByDimension(initialValue: String) {}
        func goBack() {}
    }

    class ViewModelMock: FilterLocationsViewModel {
        var filter = LocationFilter()

        func onViewMount() {}
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
