import SwiftUI

// MARK: - View
struct FilterCharactersStack: View {
    let mainContainer: MainContainer
    @Environment(\.dismiss) var dismiss

    @State private var path = NavigationPath()
    @State private var mainScreenParams = FilterCharactersScreenParams(name: .none, species: .none)

    var body: some View {
        NavigationStack(path: $path) {
            FilterCharactersScreen(
                router: SwiftUIFilterCharactersScreenRouter(path: $path, params: mainScreenParams, dismiss: dismiss)
            ) {
                mainContainer.characters.filterCharactersViewModel
            }
            .navigationDestination(for: SearchScreens.self) { screen in
                switch screen {
                case .byName(let params):
                    SearchScreen(
                        router: SwiftUISearchByNameRouter(
                            path: $path,
                            params: params,
                            mainScreenParams: $mainScreenParams
                        )
                    ) {
                        mainContainer.search.searchViewModel(
                            autocompleteRepository: mainContainer.search.autocompleteByCharacterNameRepository
                        )
                    }
                case .bySpecies(let params):
                    SearchScreen(
                        router: SwiftUISearchBySpeciesRouter(
                            path: $path,
                            params: params,
                            mainScreenParams: $mainScreenParams
                        )
                    ) {
                        mainContainer.search.searchViewModel(
                            autocompleteRepository: mainContainer.search.autocompleteByCharacterSpeciesRepository
                        )
                    }
                }
            }
        }
    }
}

// MARK: - Routers
extension FilterCharactersStack {
    enum SearchScreens: Hashable {
        case byName(SearchScreenParams)
        case bySpecies(SearchScreenParams)
    }

    class SwiftUIFilterCharactersScreenRouter: Router & FilterCharactersScreenRouter {
        let params: FilterCharactersScreenParams
        let dismiss: DismissAction

        init(path: Binding<NavigationPath>, params: FilterCharactersScreenParams, dismiss: DismissAction) {
            self.params = params
            self.dismiss = dismiss
            super.init(path: path)
        }

        func goSearchByName(initialValue: String) {
            path.wrappedValue.append(
                SearchScreens.byName(.init(titleLocalizationKey: "section/name-title", initialValue: initialValue))
            )
        }

        func goSearchBySpecies(initialValue: String) {
            path.wrappedValue.append(
                SearchScreens.bySpecies(.init(
                    titleLocalizationKey: "section/species-title",
                    initialValue: initialValue)
                )
            )
        }

        func goBack() {
            dismiss()
        }
    }

    class SwiftUISearchByNameRouter: Router & SearchScreenRouter {
        let params: SearchScreenParams
        let mainScreenParams: Binding<FilterCharactersScreenParams>

        init(
            path: Binding<NavigationPath>,
            params: SearchScreenParams,
            mainScreenParams: Binding<FilterCharactersScreenParams>
        ) {
            self.params = params
            self.mainScreenParams = mainScreenParams
            super.init(path: path)
        }

        func goBackWithResult(value: String) {
            mainScreenParams.wrappedValue = FilterCharactersScreenParams(name: value, species: .none)
            path.wrappedValue.removeLast()
        }
    }

    class SwiftUISearchBySpeciesRouter: Router & SearchScreenRouter {
        var params: SearchScreenParams
        let mainScreenParams: Binding<FilterCharactersScreenParams>

        init(
            path: Binding<NavigationPath>,
            params: SearchScreenParams,
            mainScreenParams: Binding<FilterCharactersScreenParams>
        ) {
            self.params = params
            self.mainScreenParams = mainScreenParams
            super.init(path: path)
        }

        func goBackWithResult(value: String) {
            mainScreenParams.wrappedValue = FilterCharactersScreenParams(name: .none, species: value)
            path.wrappedValue.removeLast()
        }
    }
}
