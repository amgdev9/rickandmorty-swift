import SwiftUI

struct ShowCharactersScreen<ViewModel>: View where ViewModel: ShowCharactersViewModel {
    @StateObject private var viewModel: ViewModel
    let router: ShowCharactersScreenRouter

    init(router: ShowCharactersScreenRouter, viewModelFactory: @escaping () -> ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModelFactory())
        self.router = router

        configureNavBarStyles()
    }

    var body: some View {
        VStack {
            CharacterList(state: viewModel.listState,
                          onRefetch: viewModel.refetch,
                          onLoadNextPage: viewModel.loadNextPage,
                          onPress: router.gotoCharacterDetail)
                .padding(.top, 20)
        }.navigationTitle(String(localized: "routes/character"))
            .toolbar {
                FilterButton(showDot: viewModel.hasFilters, action: router.gotoCharacterFilters)
            }
            .onAppear(perform: viewModel.onViewMount)
    }
}

// MARK: - Styles
extension ShowCharactersScreen {
    func configureNavBarStyles() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.backgroundColor = UIColor(Color.gray92)
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
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
        func onViewMount() {}
        var listState: ListState<CharacterSummary> = .data(CharacterListPreviews.characters.map {
            CharacterSummary.Builder()
                .set(id: $0.id)
                .set(name: $0.name)
                .set(imageURL: $0.imageURL)
                .set(status: $0.status)
                .build()
        })
        var hasFilters: Bool = true

        func loadNextPage() async {}
        func refetch() async {}
    }

    static var previews: some View {
        NavigationStack {
            ShowCharactersScreen(router: RouterMock()) {
                ViewModelMock()
            }
        }
    }
}
