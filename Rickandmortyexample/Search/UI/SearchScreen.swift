import SwiftUI

struct SearchScreen<ViewModel>: View where ViewModel: SearchViewModel {
    @StateObject private var viewModel: ViewModel
    let router: SearchScreenRouter

    init(router: SearchScreenRouter, viewModelFactory: @escaping () -> ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModelFactory())
        self.router = router
    }

    var body: some View {
        VStack {
            Divider()
            Color.white
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(String(localized: router.title), variant: .body15, weight: .semibold, color: .basicBlack)
            }
        }
        .searchable(text: $viewModel.searchText)
    }
}

// MARK: - Types
protocol SearchScreenRouter {
    var title: String.LocalizationValue { get } // TODO
    func goBackWithResult(value: String)    // TODO
}

// MARK: - Previews
struct SearchScreenPreviews: PreviewProvider {
    class RouterMock: SearchScreenRouter {
        var title: String.LocalizationValue = "section/name-title"
        func goBackWithResult(value: String) {}
    }

    class ViewModelMock: SearchViewModel {
        var searchText = ""
    }

    static var previews: some View {
        NavigationStack {
            SearchScreen(router: RouterMock()) {
                ViewModelMock()
            }
        }
    }
}
