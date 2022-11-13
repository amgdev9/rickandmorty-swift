import SwiftUI

struct ShowCharactersScreen: View {
    @StateObject private var viewModel: ShowCharactersViewModel
    let router: ShowCharactersScreenRouter

    init(router: ShowCharactersScreenRouter, viewModelFactory: @escaping () -> ShowCharactersViewModel) {
        _viewModel = StateObject(wrappedValue: viewModelFactory())
        self.router = router
    }

    var body: some View {
        VStack {
            Text(viewModel.example, variant: .body15)
            Button("Change") { viewModel.change() }
            Button("Filter") {
                router.gotoCharacterFilters(params: FilterCharactersParams())
            }
        }
    }
}

// MARK: - Types
protocol ShowCharactersScreenRouter {
    func gotoCharacterFilters(params: FilterCharactersParams)
}
