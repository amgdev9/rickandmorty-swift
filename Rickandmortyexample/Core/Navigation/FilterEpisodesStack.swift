import SwiftUI

// MARK: - View
struct FilterEpisodesStack: View {
    let mainContainer: MainContainer
    @Environment(\.dismiss) var dismiss

    @State private var path = NavigationPath()
    @State private var mainScreenParams = FilterEpisodesScreenParams(name: .none, episode: .none)

    var body: some View {
        NavigationStack(path: $path) {
            FilterEpisodesScreen(router: SwiftUIFilterEpisodesScreenRouter(path: $path, params: mainScreenParams, dismiss: dismiss)) {
                mainContainer.filterEpisodesViewModel
            }
            .navigationDestination(for: SearchScreens.self) { screenType in
                switch screenType {
                case .byName(let params):
                    SearchScreen(router: SwiftUISearchByNameRouter(path: $path, params: params, mainScreenParams: $mainScreenParams)) {
                        mainContainer.searchViewModel
                    }
                case .byEpisode(let params):
                    SearchScreen(router: SwiftUISearchByEpisodeRouter(path: $path, params: params, mainScreenParams: $mainScreenParams)) {
                        mainContainer.searchViewModel
                    }
                }
            }
        }
    }
}

// MARK: - Routers
extension FilterEpisodesStack {
    enum SearchScreens: Hashable {
        case byName(SearchScreenParams)
        case byEpisode(SearchScreenParams)
    }

    class SwiftUIFilterEpisodesScreenRouter: Router & FilterEpisodesScreenRouter {
        var params: FilterEpisodesScreenParams
        let dismiss: DismissAction

        init(path: Binding<NavigationPath>, params: FilterEpisodesScreenParams, dismiss: DismissAction) {
            self.params = params
            self.dismiss = dismiss
            super.init(path: path)
        }

        func goSearchByName(initialValue: String) {
            path.wrappedValue.append(SearchScreens.byName(.init(titleLocalizationKey: "section/name-title", initialValue: initialValue)))
        }

        func goSearchByEpisode(initialValue: String) {
            path.wrappedValue.append(SearchScreens.byEpisode(.init(titleLocalizationKey: "section/episode", initialValue: initialValue)))
        }

        func goBack() {
            dismiss()
        }
    }

    class SwiftUISearchByNameRouter: Router & SearchScreenRouter {
        var params: SearchScreenParams
        let mainScreenParams: Binding<FilterEpisodesScreenParams>

        init(path: Binding<NavigationPath>, params: SearchScreenParams, mainScreenParams: Binding<FilterEpisodesScreenParams>) {
            self.params = params
            self.mainScreenParams = mainScreenParams
            super.init(path: path)
        }

        func goBackWithResult(value: String) {
            mainScreenParams.wrappedValue = FilterEpisodesScreenParams(name: value, episode: .none)
            path.wrappedValue.removeLast()
        }
    }

    class SwiftUISearchByEpisodeRouter: Router & SearchScreenRouter {
        var params: SearchScreenParams
        let mainScreenParams: Binding<FilterEpisodesScreenParams>

        init(path: Binding<NavigationPath>, params: SearchScreenParams, mainScreenParams: Binding<FilterEpisodesScreenParams>) {
            self.params = params
            self.mainScreenParams = mainScreenParams
            super.init(path: path)
        }

        func goBackWithResult(value: String) {
            mainScreenParams.wrappedValue = FilterEpisodesScreenParams(name: .none, episode: value)
            path.wrappedValue.removeLast()
        }
    }
}
