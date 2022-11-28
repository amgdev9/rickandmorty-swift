import SwiftUI

struct SearchScreen<ViewModel>: View where ViewModel: SearchViewModel {
    @StateObject private var viewModel: ViewModel
    let router: SearchScreenRouter

    init(router: SearchScreenRouter, viewModelFactory: @escaping () -> ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModelFactory())
        self.router = router
    }

    var body: some View {
        NavigationContainer(title: String(localized: router.title), color: .basicWhite) {
            VStack {
                Divider()
                Color.white
            }
        }
        .autocompleteBar(
            searchText: $viewModel.searchText,
            autocompletions: viewModel.suggestions,
            onAutocomplete: viewModel.search
        )
        .onSubmit(of: .search) {
            router.goBackWithResult(value: viewModel.searchText)
        }
    }
}

// MARK: - Types
protocol SearchScreenRouter {
    var title: String.LocalizationValue { get }
    var initialValue: String { get }
    func goBackWithResult(value: String)
}

// MARK: - Previews
struct SearchScreenPreviews: PreviewProvider {
    class RouterMock: SearchScreenRouter {
        var initialValue = ""
        var title: String.LocalizationValue = "section/name-title"
        func goBackWithResult(value: String) {}
    }

    class ViewModelMock: SearchViewModel {
        func search(text: String) {}

        var searchText = ""
        var suggestions: [String] = ["Rick", "Morty"]
    }

    static var previews: some View {
        NavigationStack {
            SearchScreen(router: RouterMock()) {
                ViewModelMock()
            }
        }
    }
}
