import SwiftUI

// MARK: - View
struct FilterEpisodesScreen<ViewModel>: View where ViewModel: FilterEpisodesViewModel {
    @StateObject private var viewModel: ViewModel
    let router: FilterEpisodesScreenRouter

    init(router: FilterEpisodesScreenRouter, viewModelFactory: @escaping () -> ViewModel) {
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
                        router.goSearch()
                    }.padding(.bottom, 19)
                SectionButton(
                    title: String(localized: "section/episode"),
                    subtitle: String(localized: "action/select-one"),
                    active: !viewModel.filter.episode.isEmpty) {
                        router.goSearch()
                    }.padding(.bottom, 19)
            }
        }
        .presentationDetents([.fraction(1), .large])
    }
}

// MARK: - Types
protocol FilterEpisodesScreenRouter {
    func goBack()
    func goSearch() // TODO
}

// MARK: - Previews
struct FilterEpisodesScreenPreviews: PreviewProvider {
    class RouterMock: FilterEpisodesScreenRouter {
        func goSearch() {}
        func goBack() {}
    }

    class ViewModelMock: FilterEpisodesViewModel {
        var filter = EpisodeFilter()

        func onPressApply(goBack: () -> Void) {}
        func onPressClear() {}
    }

    static var previews: some View {
        NavigationStack {}
        .sheet(isPresented: .init(get: { true }, set: {_ in })) {
            FilterEpisodesScreen(router: RouterMock()) {
                ViewModelMock()
            }
        }
    }
}