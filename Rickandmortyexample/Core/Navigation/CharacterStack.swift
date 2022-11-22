import SwiftUI

// MARK: - View
struct CharacterStack: View {
    let mainContainer: MainContainer

    @State private var path = NavigationPath()
    @State private var filterSheetPresented = false

    var body: some View {
        NavigationStack(path: $path) {
            ShowCharactersScreen(router: SwiftUIShowCharactersScreenRouter(path: $path,
                                                                        filterSheetPresented: $filterSheetPresented)) {
                mainContainer.showCharactersViewModel
            }
            .navigationDestination(for: FilterCharactersParams.self) { _ in
                CharacterDetailsScreen(router: SwiftUICharacterDetailsScreenRouter(path: $path)) {
                    mainContainer.characterDetailsViewModel
                }
            }
            .sheet(isPresented: $filterSheetPresented) {
                FilterCharactersScreen(router: SwiftUIFilterCharactersScreenRouter(path: $path)) {
                    mainContainer.filterCharactersViewModel
                }
            }
        }
    }
}

// MARK: - Routers
extension CharacterStack {
    class SwiftUIShowCharactersScreenRouter: Router & ShowCharactersScreenRouter {
        let filterSheetPresented: Binding<Bool>

        init(path: Binding<NavigationPath>, filterSheetPresented: Binding<Bool>) {
            self.filterSheetPresented = filterSheetPresented
            super.init(path: path)
        }

        func gotoCharacterFilters() {
            filterSheetPresented.wrappedValue = true
        }

        func gotoCharacterDetail(id: String) {
            path.wrappedValue.append(CharacterDetailsParams(id: id))
        }
    }

    class SwiftUIFilterCharactersScreenRouter: Router & FilterCharactersScreenRouter {
        func goSearch() {
            // TODO
        }

        func goBack() {
            path.wrappedValue.removeLast()
        }
    }

    class SwiftUICharacterDetailsScreenRouter: Router & CharacterDetailsScreenRouter {
        func gotoLocation(id: String) {
            // TODO
        }

        func gotoEpisode(id: String) {
            // TODO
        }
    }
}
