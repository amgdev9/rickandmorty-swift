import SwiftUI

struct ShowLocationsScreen: View {
    @StateObject private var viewModel: ShowLocationsViewModel

    init(viewModelFactory: @escaping () -> ShowLocationsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModelFactory())
    }

    var body: some View {
        VStack {
            Text("Locations list", variant: .body15)
        }
    }
}
