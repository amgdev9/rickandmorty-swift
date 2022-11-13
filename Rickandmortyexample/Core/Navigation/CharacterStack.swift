import SwiftUI

// MARK: - View
struct CharacterStack: View {
    let mainContainer: MainContainer

    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            ShowCharactersScreen(router: ShowCharactersScreenRouterImpl(path: $path)) {
                mainContainer.showCharactersViewModel
            }
            .navigationDestination(for: FilterCharactersParams.self) { _ in
                FilterCharactersScreen(router: FilterCharactersScreenRouterImpl(path: $path)) {
                    mainContainer.filterCharactersViewModel
                }
            }
        }
    }
}

// MARK: - Routers
extension CharacterStack {
    class ShowCharactersScreenRouterImpl: Router & ShowCharactersScreenRouter {
        func gotoCharacterFilters(params: FilterCharactersParams) {
            path.wrappedValue.append(params)
        }
    }

    class FilterCharactersScreenRouterImpl: Router & FilterCharactersScreenRouter {
        func goBack() {
            path.wrappedValue.removeLast()
        }
    }
}
