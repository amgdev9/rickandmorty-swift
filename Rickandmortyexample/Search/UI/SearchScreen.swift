import SwiftUI

struct SearchScreen<ViewModel>: View where ViewModel: SearchViewModel {
    @StateObject private var viewModel: ViewModel
    let router: SearchScreenRouter

    init(router: SearchScreenRouter, viewModelFactory: @escaping () -> ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModelFactory())
        self.router = router
    }

    var title: String {
        String(localized: String.LocalizationValue(router.params.titleLocalizationKey))
    }

    var body: some View {
        NavigationContainer(title: title, color: .basicWhite) {
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
    var params: SearchScreenParams { get }

    func goBackWithResult(value: String)
}

struct SearchScreenParams: Hashable {
    let titleLocalizationKey: String
    let initialValue: String
}

// MARK: - Previews
struct SearchScreenPreviews: PreviewProvider {
    class RouterMock: SearchScreenRouter {
        var params = SearchScreenParams(titleLocalizationKey: "section/name-title", initialValue: "")
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
