import SwiftUI

struct ShowEpisodesScreen: View {
    @StateObject private var viewModel: ShowEpisodesViewModel

    init(viewModelFactory: @escaping () -> ShowEpisodesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModelFactory())
    }

    var body: some View {
        VStack {
            Text("Episodes list", variant: .body15)
        }
    }
}
