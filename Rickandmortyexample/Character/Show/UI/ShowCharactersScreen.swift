import SwiftUI
import AlertToast

struct ShowCharactersScreen<ViewModel>: View where ViewModel: ShowCharactersViewModel {
    @StateObject private var viewModel: ViewModel
    let router: ShowCharactersScreenRouter

    @EnvironmentObject var i18n: I18N

    init(router: ShowCharactersScreenRouter, viewModelFactory: @escaping () -> ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModelFactory())
        self.router = router
    }

    var body: some View {
        NavigationContainer(title: i18n.t("routes/character")) {
            PaginatedList(
                data: viewModel.listState,
                onRefetch: viewModel.refetch,
                onLoadNextPage: viewModel.fetchNextPage
            ) { characters in
                CharacterList(characters: characters,
                              onPress: router.gotoCharacterDetail)
                .padding(.top, 20)
            }
        }
        .toolbar {
            FilterButton(showDot: viewModel.hasFilters, action: router.gotoCharacterFilters)
        }
        .onMount(perform: viewModel.onViewMount)
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
        var listState: NetworkData<PaginatedResponse<CharacterSummary>> = .data(PaginatedResponse(items: (1...10).map { i in
            CharacterSummary.Mother.build(id: String(i))
        }, hasNext: false))
        var hasFilters: Bool = true

        func fetchNextPage() async {
            await PreviewUtils.delay()
        }
        func refetch() async {
            await PreviewUtils.delay()
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
