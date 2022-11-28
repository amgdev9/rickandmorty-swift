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
                mainContainer.showCharactersViewModel
            }
            .navigationDestination(for: CharacterDetailsScreenParams.self) { params in
                CharacterDetailsScreen(router: SwiftUICharacterDetailsScreenRouter(path: $path, params: params)) {
                    mainContainer.characterDetailsViewModel
                }
            }
            .navigationDestination(for: LocationDetailsScreenParams.self) { params in
                LocationDetailsScreen(router: SwiftUILocationDetailsScreenRouter(path: $path, params: params)) {
                    mainContainer.locationDetailsViewModel
                }
            }
            .navigationDestination(for: EpisodeDetailsScreenParams.self) { params in
                EpisodeDetailsScreen(router: SwiftUIEpisodeDetailsScreenRouter(path: $path, params: params)) {
                    mainContainer.episodeDetailsViewModel
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

    class SwiftUICharacterDetailsScreenRouter: Router & CharacterDetailsScreenRouter {
        var params: CharacterDetailsScreenParams

        init(path: Binding<NavigationPath>, params: CharacterDetailsScreenParams) {
            self.params = params
            super.init(path: path)
        }

        func gotoLocation(id: String) {
            path.wrappedValue.append(LocationDetailsScreenParams(id: id))
        }

        func gotoEpisode(id: String) {
            path.wrappedValue.append(EpisodeDetailsScreenParams(id: id))
        }
    }

    class SwiftUILocationDetailsScreenRouter: Router & LocationDetailsScreenRouter {
        var params: LocationDetailsScreenParams

        init(path: Binding<NavigationPath>, params: LocationDetailsScreenParams) {
            self.params = params
            super.init(path: path)
        }

        func gotoCharacter(id: String) {
            path.wrappedValue.append(CharacterDetailsScreenParams(id: id))
        }
    }

    class SwiftUIEpisodeDetailsScreenRouter: Router & EpisodeDetailsScreenRouter {
        var params: EpisodeDetailsScreenParams

        init(path: Binding<NavigationPath>, params: EpisodeDetailsScreenParams) {
            self.params = params
            super.init(path: path)
        }

        func gotoCharacter(id: String) {
            path.wrappedValue.append(CharacterDetailsScreenParams(id: id))
        }
    }
}
