import SwiftUI

// MARK: - View
struct LocationStack: View {
    let mainContainer: MainContainer

    @State private var path = NavigationPath()
    @State private var filterSheetPresented = false

    var body: some View {
        NavigationStack(path: $path) {
            ShowLocationsScreen(router: SwiftUISShowLocationsScreenRouter(path: $path)) {
                mainContainer.showLocationsViewModel
            }
        }
    }
}

// MARK: - Routers
extension LocationStack {
    class SwiftUISShowLocationsScreenRouter: Router & ShowLocationsScreenRouter {
        func gotoLocationFilters() {
            // TODO
        }

        func gotoLocationDetail(id: String) {
            // TODO
        }
    }
}
