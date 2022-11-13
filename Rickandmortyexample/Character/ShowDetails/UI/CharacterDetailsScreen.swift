import SwiftUI

struct CharacterDetailsScreen: View {
    @StateObject private var viewModel: CharacterDetailsViewModel
    let router: CharacterDetailsScreenRouter

    init(router: CharacterDetailsScreenRouter, viewModelFactory: @escaping () -> CharacterDetailsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModelFactory())
        self.router = router
    }

    var body: some View {
        VStack {
            Text("Character details", variant: .body15)
        }
    }
}

// MARK: - Types
protocol CharacterDetailsScreenRouter {
    func gotoLocation(id: String)
    func gotoEpisode(id: String)
}
