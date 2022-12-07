import SwiftUI

// MARK: - View
struct FilterEpisodesScreen<ViewModel>: View where ViewModel: FilterEpisodesViewModel {
    @StateObject private var viewModel: ViewModel
    let router: FilterEpisodesScreenRouter

    @EnvironmentObject var i18n: I18N

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
                    title: i18n.t("section/name-title"),
                    subtitle: i18n.t("section/name-subtitle"),
                    active: !viewModel.filter.name.isEmpty) {
                        router.goSearchByName(initialValue: viewModel.filter.name)
                    }.padding(.bottom, 19)
                SectionButton(
                    title: i18n.t("section/episode"),
                    subtitle: i18n.t("action/select-one"),
                    active: !viewModel.filter.episode.isEmpty) {
                        router.goSearchByEpisode(initialValue: viewModel.filter.episode)
                    }.padding(.bottom, 19)
            }
        }
        .presentationDetents([.fraction(1), .large])
        .onMount(perform: viewModel.onViewMount)
        .onChange(of: router.params, perform: { params in
            if let name = params.name {
                ($viewModel.filter.name).wrappedValue = name
            }
            if let episode = params.episode {
                ($viewModel.filter.episode).wrappedValue = episode
            }
        })
    }
}

// MARK: - Types
protocol FilterEpisodesScreenRouter {
    var params: FilterEpisodesScreenParams { get }

    func goBack()
    func goSearchByName(initialValue: String)
    func goSearchByEpisode(initialValue: String)
}

struct FilterEpisodesScreenParams: Hashable {
    let name: String?
    let episode: String?
}

// MARK: - Previews
struct FilterEpisodesScreenPreviews: PreviewProvider {
    class RouterMock: FilterEpisodesScreenRouter {
        var params = FilterEpisodesScreenParams(name: .none, episode: .none)

        func goSearchByName(initialValue: String) {}
        func goSearchByEpisode(initialValue: String) {}
        func goBack() {}
    }

    class ViewModelMock: FilterEpisodesViewModel {
        var filter = EpisodeFilter()

        func onViewMount() {}
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
