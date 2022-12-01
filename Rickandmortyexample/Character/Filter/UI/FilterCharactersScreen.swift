import SwiftUI

// MARK: - View
struct FilterCharactersScreen<ViewModel>: View where ViewModel: FilterCharactersViewModel {
    @StateObject private var viewModel: ViewModel
    let router: FilterCharactersScreenRouter

    private let statusList: [Character.Status] = [.alive, .dead, .unknown]
    private let genderList: [Character.Gender] = [.female, .male, .genderless, .unknown]

    init(router: FilterCharactersScreenRouter, viewModelFactory: @escaping () -> ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModelFactory())
        self.router = router
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                FilterHeader(onPressApply: { viewModel.onPressApply(goBack: router.goBack)
                }, onPressClear: viewModel.onPressClear, clearDisabled: viewModel.filter.isEmpty)
                .padding(.bottom, 26.5)
                .padding(.top, 18)
                SectionButton(
                    title: String(localized: "section/name-title"),
                    subtitle: String(localized: "section/name-subtitle"),
                    active: !viewModel.filter.name.isEmpty) {
                        router.goSearchByName(initialValue: viewModel.filter.name)
                    }.padding(.bottom, 19)
                SectionButton(
                    title: String(localized: "section/species-title"),
                    subtitle: String(localized: "action/select-one"),
                    active: !viewModel.filter.species.isEmpty) {
                        router.goSearchBySpecies(initialValue: viewModel.filter.species)
                    }.padding(.bottom, 19.5)
                RadioButtonGroup(
                    title: String(localized: "section/status"),
                    values: statusList,
                    value: $viewModel.filter.status)
                .padding(.bottom, 29.5)
                RadioButtonGroup(
                    title: String(localized: "section/gender"),
                    values: genderList,
                    value: $viewModel.filter.gender)
            }
        }
        .presentationDetents([.fraction(1), .large])
        .onChange(of: router.params, perform: { params in
            if let name = params.name {
                ($viewModel.filter.name).wrappedValue = name
            }
            if let species = params.species {
                ($viewModel.filter.species).wrappedValue = species
            }
        })
    }
}

// MARK: - Types
protocol FilterCharactersScreenRouter {
    var params: FilterCharactersScreenParams { get }

    func goBack()
    func goSearchByName(initialValue: String)
    func goSearchBySpecies(initialValue: String)
}

struct FilterCharactersScreenParams: Hashable {
    let name: String?
    let species: String?
}

// MARK: - Previews
struct FilterCharactersScreenPreviews: PreviewProvider {
    class RouterMock: FilterCharactersScreenRouter {
        func goSearchByName(initialValue: String) {}
        func goSearchBySpecies(initialValue: String) {}

        var params = FilterCharactersScreenParams(name: .none, species: .none)

        func goBack() {}
    }

    class ViewModelMock: FilterCharactersViewModel {
        var loading = false
        var filter = CharacterFilter()

        func onViewMount() {}
        func onPressApply(goBack: () -> Void) {}
        func onPressClear() {}
    }

    static var previews: some View {
        NavigationStack {}
        .sheet(isPresented: .init(get: { true }, set: {_ in })) {
            FilterCharactersScreen(router: RouterMock()) {
                ViewModelMock()
            }
        }
    }
}
