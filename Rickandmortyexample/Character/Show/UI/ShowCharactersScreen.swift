import SwiftUI
import AlertToast

struct ShowCharactersScreen<ViewModel>: View where ViewModel: ShowCharactersViewModel {
    @StateObject private var viewModel: ViewModel
    let router: ShowCharactersScreenRouter

    init(router: ShowCharactersScreenRouter, viewModelFactory: @escaping () -> ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModelFactory())
        self.router = router
    }

    var body: some View {
        NavigationContainer(title: String(localized: "routes/character")) {
            CharacterList(state: viewModel.listState,
                          onRefetch: viewModel.refetch,
                          onLoadNextPage: viewModel.loadNextPage,
                          onPress: router.gotoCharacterDetail)
            .padding(.top, 20)
        }
        .toolbar {
            FilterButton(showDot: viewModel.hasFilters, action: router.gotoCharacterFilters)
        }
        .onAppear(perform: viewModel.onViewMount)
        .errorAlert($viewModel.error)
    }
}

// MARK: - Types
protocol ShowCharactersScreenRouter {
    func gotoCharacterFilters()
    func gotoCharacterDetail(id: String)
}

extension CharacterSummary: CharacterCardItem {}

// MARK: - Previews
struct ShowCharactersScreenPreviews: PreviewProvider {

    class RouterMock: ShowCharactersScreenRouter {
        func gotoCharacterFilters() {}
        func gotoCharacterDetail(id: String) {}
    }

    class ViewModelMock: ShowCharactersViewModel {
        var error: Error? = .none

        func onViewMount() {}
        var listState: NetworkData<[CharacterSummary]> = .data(CharacterListPreviews.characters.map {
            CharacterSummary.Builder()
                .set(id: $0.id)
                .set(name: $0.name)
                .set(imageURL: $0.imageURL)
                .set(status: $0.status)
                .build()
        })
        var hasFilters: Bool = true

        func loadNextPage() async {}
        func refetch() async {
            do {
                try await Task.sleep(nanoseconds: 4_000_000_000)
            } catch {}
        }
    }

    static var previews: some View {
        NavigationStack {
            ShowCharactersScreen(router: RouterMock()) {
                ViewModelMock()
            }
        }
    }
}
