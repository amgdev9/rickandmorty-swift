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
                }, onPressClear: viewModel.onPressClear)
                .padding(.bottom, 26.5)
                .padding(.top, 18)
                SectionButton(
                    title: String(localized: "section/name-title"),
                    subtitle: String(localized: "section/name-subtitle"),
                    active: !viewModel.filter.name.isEmpty) {
                        router.goSearch()
                    }.padding(.bottom, 19)
                SectionButton(
                    title: String(localized: "section/species-title"),
                    subtitle: String(localized: "section/species-subtitle"),
                    active: !viewModel.filter.species.isEmpty) {
                        router.goSearch()
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
    }
}

// MARK: - Types
protocol FilterCharactersScreenRouter {
    func goBack()
    func goSearch() // TODO
}

// MARK: - Previews
struct FilterCharactersScreenPreviews: PreviewProvider {
    class RouterMock: FilterCharactersScreenRouter {
        func goSearch() {}
        func goBack() {}
    }

    class ViewModelMock: FilterCharactersViewModel {
        var filter = CharacterFilter()

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
