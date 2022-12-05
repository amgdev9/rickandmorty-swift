import SwiftUI

// MARK: - View
struct EpisodeStack: View {
    let mainContainer: MainContainer

    @State private var path = NavigationPath()
    @State private var filterPresented = false

    var body: some View {
        NavigationStack(path: $path) {
            ShowEpisodesScreen(router: SwiftUIShowEpisodesScreenRouter(path: $path,
                                                                        filterPresented: $filterPresented)) {
                mainContainer.episodes.showEpisodesViewModel
            }
            .navigationDestination(for: EpisodeDetailsScreenParams.self) { params in
                EpisodeDetailsScreen(router: SwiftUIEpisodeDetailsScreenRouter(path: $path, params: params)) {
                    mainContainer.episodes.episodeDetailsViewModel
                }
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
            .sheet(isPresented: $filterPresented) {
                FilterCharactersStack(mainContainer: mainContainer)
            }
        }
    }
}

// MARK: - Routers
extension EpisodeStack {
    class SwiftUIShowEpisodesScreenRouter: Router & ShowEpisodesScreenRouter {
        let filterPresented: Binding<Bool>

        init(path: Binding<NavigationPath>, filterPresented: Binding<Bool>) {
            self.filterPresented = filterPresented
            super.init(path: path)
        }

        func gotoEpisodeFilters() {
            filterPresented.wrappedValue = true
        }

        func gotoEpisodeDetail(id: String) {
            path.wrappedValue.append(EpisodeDetailsScreenParams(id: id))
        }
    }
}
