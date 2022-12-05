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
                mainContainer.locations.showLocationsViewModel
            }
            .navigationDestination(for: LocationDetailsScreenParams.self) { params in
                LocationDetailsScreen(router: SwiftUILocationDetailsScreenRouter(path: $path, params: params)) {
                    mainContainer.locations.locationDetailsViewModel
                }
            }
            .navigationDestination(for: CharacterDetailsScreenParams.self) { params in
                CharacterDetailsScreen(router: SwiftUICharacterDetailsScreenRouter(path: $path, params: params)) {
                    mainContainer.characters.characterDetailsViewModel
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
}
