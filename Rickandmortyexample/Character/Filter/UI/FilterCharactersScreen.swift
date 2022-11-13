import SwiftUI

struct FilterCharactersScreen: View {
    @StateObject private var viewModel: FilterCharactersViewModel
    let router: FilterCharactersScreenRouter

    init(router: FilterCharactersScreenRouter, viewModelFactory: @escaping () -> FilterCharactersViewModel) {
        _viewModel = StateObject(wrappedValue: viewModelFactory())
        self.router = router
    }

    var body: some View {
        VStack {
            Text("Character Filters", variant: .body15)
            Button("Back") {
                router.goBack()
            }
        }
    }
}

// MARK: - Types
protocol FilterCharactersScreenRouter {
    func goBack()
}
