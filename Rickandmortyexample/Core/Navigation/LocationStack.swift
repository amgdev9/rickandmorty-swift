import SwiftUI

// MARK: - View
struct LocationStack: View {
    let mainContainer: MainContainer

    @State private var path = NavigationPath()
    @State private var filterPresented = false

    var body: some View {
        NavigationStack(path: $path) {
            ShowLocationsScreen(router: SwiftUIShowLocationsScreenRouter(path: $path,
                                                                        filterPresented: $filterPresented)) {
                mainContainer.showLocationsViewModel
            }
            .navigationDestination(for: LocationDetailsScreenParams.self) { params in
                LocationDetailsScreen(router: SwiftUILocationDetailsScreenRouter(path: $path, params: params)) {
                    mainContainer.locationDetailsViewModel
                }
            }
            .navigationDestination(for: CharacterDetailsScreenParams.self) { params in
                CharacterDetailsScreen(router: SwiftUICharacterDetailsScreenRouter(path: $path, params: params)) {
                    mainContainer.characterDetailsViewModel
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
extension LocationStack {
    class SwiftUIShowLocationsScreenRouter: Router & ShowLocationsScreenRouter {
        let filterPresented: Binding<Bool>

        init(path: Binding<NavigationPath>, filterPresented: Binding<Bool>) {
            self.filterPresented = filterPresented
            super.init(path: path)
        }

        func gotoLocationFilters() {
            filterPresented.wrappedValue = true
        }

        func gotoLocationDetail(id: String) {
            path.wrappedValue.append(LocationDetailsScreenParams(id: id))
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
