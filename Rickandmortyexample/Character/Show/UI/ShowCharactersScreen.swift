import SwiftUI

struct ShowCharactersScreen: View {
    @StateObject private var viewModel: ShowCharactersViewModel
    let router: ShowCharactersScreenRouter

    init(router: ShowCharactersScreenRouter, viewModelFactory: @escaping () -> ShowCharactersViewModel) {
        _viewModel = StateObject(wrappedValue: viewModelFactory())
        self.router = router

        configureNavBarStyles()
    }

    func configureNavBarStyles() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.backgroundColor = UIColor(Color.gray92)
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }

    var body: some View {
        VStack {
            Text(viewModel.example, variant: .body15)
        }.navigationTitle(String(localized: "routes/character"))
            .toolbar {
                FilterButton(showDot: false, action: router.gotoCharacterFilters)
            }
    }
}

// MARK: - Types
protocol ShowCharactersScreenRouter {
    func gotoCharacterFilters()
    func gotoCharacterDetail(params: CharacterDetailsParams)
}

// MARK: - Previews
struct ShowCharactersScreenPreviews: PreviewProvider {

    class RouterMock: ShowCharactersScreenRouter {
        func gotoCharacterFilters() {
            print("gotoCharacterFilters")
        }

        func gotoCharacterDetail(params: CharacterDetailsParams) {
            print("gotoCharacterDetail", params)
        }
    }

    class ViewModelMock: ShowCharactersViewModel {
        override init() {
            super.init()
            self.example = "Mock test"
        }

        override func change() {
            print("change")
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
