import SwiftUI

// MARK: - View
struct CharacterStack: View {
    let mainContainer: MainContainer

    @State private var path = NavigationPath()
    @State private var filterPresented = false

    var body: some View {
        NavigationStack(path: $path) {
            ShowCharactersScreen(router: SwiftUIShowCharactersScreenRouter(path: $path,
                                                                        filterPresented: $filterPresented)) {
                mainContainer.characters.showCharactersViewModel
            }
            .navigationDestination(for: CharacterDetailsScreenParams.self) { params in
                CharacterDetailsScreen(router: SwiftUICharacterDetailsScreenRouter(path: $path, params: params)) {
                    mainContainer.characters.characterDetailsViewModel
                }
            }
            .navigationDestination(for: LocationDetailsScreenParams.self) { params in
                LocationDetailsScreen(router: SwiftUILocationDetailsScreenRouter(path: $path, params: params)) {
                    mainContainer.locations.locationDetailsViewModel
                }
            }
            .navigationDestination(for: EpisodeDetailsScreenParams.self) { params in
                EpisodeDetailsScreen(router: SwiftUIEpisodeDetailsScreenRouter(path: $path, params: params)) {
                    mainContainer.episodes.episodeDetailsViewModel
                }
            }
            .sheet(isPresented: $filterPresented) {
                FilterCharactersStack(mainContainer: mainContainer)
            }
        }
    }
}

// MARK: - Routers
extension CharacterStack {
    class SwiftUIShowCharactersScreenRouter: Router & ShowCharactersScreenRouter {
        let filterPresented: Binding<Bool>

        init(path: Binding<NavigationPath>, filterPresented: Binding<Bool>) {
            self.filterPresented = filterPresented
            super.init(path: path)
        }

        func gotoCharacterFilters() {
            filterPresented.wrappedValue = true
        }

        func gotoCharacterDetail(id: String) {
            path.wrappedValue.append(CharacterDetailsScreenParams(id: id))
        }
    }
}
