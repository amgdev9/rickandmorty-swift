import SwiftUI

// MARK: - View
struct EpisodeStack: View {
    let mainContainer: MainContainer

    @State private var path = NavigationPath()
    @State private var filterSheetPresented = false

    var body: some View {
        NavigationStack(path: $path) {
            ShowEpisodesScreen(router: SwiftUISShowEpisodesScreenRouter(path: $path)) {
                mainContainer.showEpisodesViewModel
            }
        }
    }
}

// MARK: - Routers
extension EpisodeStack {
    class SwiftUISShowEpisodesScreenRouter: Router & ShowEpisodesScreenRouter {
        func gotoEpisodeFilters() {
            // TODO
        }

        func gotoEpisodeDetail(id: String) {
            // TODO
        }
    }
}
