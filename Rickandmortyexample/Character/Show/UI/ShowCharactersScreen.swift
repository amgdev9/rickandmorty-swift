import SwiftUI

struct ShowCharactersScreen: View {
    @StateObject private var viewModel: ShowCharactersViewModel

    init(viewModelFactory: @escaping () -> ShowCharactersViewModel) {
        _viewModel = StateObject(wrappedValue: viewModelFactory())
    }

    var body: some View {
        VStack {
            Text(viewModel.example, variant: .body15)
            Button("Change") { viewModel.change() }
        }
    }
}
