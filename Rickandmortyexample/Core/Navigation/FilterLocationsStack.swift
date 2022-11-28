import SwiftUI

// MARK: - View
struct FilterLocationsStack: View {
    let mainContainer: MainContainer
    @Environment(\.dismiss) var dismiss

    @State private var path = NavigationPath()
    @State private var mainScreenParams = FilterLocationsScreenParams(name: .none, type: .none, dimension: .none)

    var body: some View {
        NavigationStack(path: $path) {
            FilterLocationsScreen(router: SwiftUIFilterLocationsScreenRouter(path: $path, params: mainScreenParams, dismiss: dismiss)) {
                mainContainer.filterLocationsViewModel
            }
            .navigationDestination(for: SearchScreens.self) { screenType in
                switch screenType {
                case .byName(let params):
                    SearchScreen(router: SwiftUISearchByNameRouter(path: $path, params: params, mainScreenParams: $mainScreenParams)) {
                        mainContainer.searchViewModel
                    }
                case .byType(let params):
                    SearchScreen(router: SwiftUISearchByTypeRouter(path: $path, params: params, mainScreenParams: $mainScreenParams)) {
                        mainContainer.searchViewModel
                    }
                case .byDimension(let params):
                    SearchScreen(router: SwiftUISearchByDimensionRouter(path: $path, params: params, mainScreenParams: $mainScreenParams)) {
                        mainContainer.searchViewModel
                    }
                }
            }
        }
    }
}

// MARK: - Routers
extension FilterLocationsStack {
    enum SearchScreens: Hashable {
        case byName(SearchScreenParams)
        case byType(SearchScreenParams)
        case byDimension(SearchScreenParams)
    }

    class SwiftUIFilterLocationsScreenRouter: Router & FilterLocationsScreenRouter {
        var params: FilterLocationsScreenParams
        let dismiss: DismissAction

        init(path: Binding<NavigationPath>, params: FilterLocationsScreenParams, dismiss: DismissAction) {
            self.params = params
            self.dismiss = dismiss
            super.init(path: path)
        }

        func goSearchByName(initialValue: String) {
            path.wrappedValue.append(SearchScreens.byName(.init(titleLocalizationKey: "section/name-title", initialValue: initialValue)))
        }

        func goSearchByType(initialValue: String) {
            path.wrappedValue.append(SearchScreens.byType(.init(titleLocalizationKey: "section/type", initialValue: initialValue)))
        }

        func goSearchByDimension(initialValue: String) {
            path.wrappedValue.append(SearchScreens.byDimension(.init(titleLocalizationKey: "section/dimension", initialValue: initialValue)))
        }

        func goBack() {
            dismiss()
        }
    }

    class SwiftUISearchByNameRouter: Router & SearchScreenRouter {
        var params: SearchScreenParams
        let mainScreenParams: Binding<FilterLocationsScreenParams>

        init(path: Binding<NavigationPath>, params: SearchScreenParams, mainScreenParams: Binding<FilterLocationsScreenParams>) {
            self.params = params
            self.mainScreenParams = mainScreenParams
            super.init(path: path)
        }

        func goBackWithResult(value: String) {
            mainScreenParams.wrappedValue = FilterLocationsScreenParams(name: value, type: .none, dimension: .none)
            path.wrappedValue.removeLast()
        }
    }

    class SwiftUISearchByTypeRouter: Router & SearchScreenRouter {
        var params: SearchScreenParams
        let mainScreenParams: Binding<FilterLocationsScreenParams>

        init(path: Binding<NavigationPath>, params: SearchScreenParams, mainScreenParams: Binding<FilterLocationsScreenParams>) {
            self.params = params
            self.mainScreenParams = mainScreenParams
            super.init(path: path)
        }

        func goBackWithResult(value: String) {
            mainScreenParams.wrappedValue = FilterLocationsScreenParams(name: .none, type: value, dimension: .none)
            path.wrappedValue.removeLast()
        }
    }

    class SwiftUISearchByDimensionRouter: Router & SearchScreenRouter {
        var params: SearchScreenParams
        let mainScreenParams: Binding<FilterLocationsScreenParams>

        init(path: Binding<NavigationPath>, params: SearchScreenParams, mainScreenParams: Binding<FilterLocationsScreenParams>) {
            self.params = params
            self.mainScreenParams = mainScreenParams
            super.init(path: path)
        }

        func goBackWithResult(value: String) {
            mainScreenParams.wrappedValue = FilterLocationsScreenParams(name: .none, type: .none, dimension: value)
            path.wrappedValue.removeLast()
        }
    }
}
