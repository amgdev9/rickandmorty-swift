import SwiftUI

struct ShowEpisodesScreen<ViewModel>: View where ViewModel: ShowEpisodesViewModel {
    @StateObject private var viewModel: ViewModel
    let router: ShowEpisodesScreenRouter

    @EnvironmentObject var i18n: I18N

    init(router: ShowEpisodesScreenRouter, viewModelFactory: @escaping () -> ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModelFactory())
        self.router = router
    }

    var body: some View {
        NavigationContainer(title: i18n.t("routes/episodes")) {
            PaginatedList(
                data: viewModel.listState,
                onRefetch: viewModel.refetch,
                onLoadNextPage: viewModel.fetchNextPage
            ) { seasons in
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(seasons, id: \.id) { season in
                        Text(
                            String(format: i18n.t("section/season"), String(season.id)),
                            variant: .body20,
                            weight: .bold,
                            color: .graybaseGray1
                        )
                            .padding(.leading, 16)
                            .padding(.top, 21)
                            .padding(.bottom, 9.5)
                        Separator()
                        EpisodeList(episodes: season.episodes, onPress: router.gotoEpisodeDetail)
                        Separator()
                    }
                }
            }
        }
        .toolbar {
            FilterButton(showDot: viewModel.hasFilters, action: router.gotoEpisodeFilters)
        }
        .onMount(perform: viewModel.onViewMount)
        .errorAlert($viewModel.error)
    }
}

// MARK: - Types
protocol ShowEpisodesScreenRouter {
    func gotoEpisodeFilters()
    func gotoEpisodeDetail(id: String)
}

// MARK: - Previews
struct ShowEpisodesScreenPreviews: PreviewProvider {
    class RouterMock: ShowEpisodesScreenRouter {
        func gotoEpisodeDetail(id: String) {}
        func gotoEpisodeFilters() {}
    }

    class ViewModelMock: ShowEpisodesViewModel {
        var listState: NetworkData<PaginatedResponse<EpisodeSeason>> = .data(PaginatedResponse(items: [
            EpisodeSeason(id: 1, episodes: EpisodeListPreviews.EPISODES),
            EpisodeSeason(id: 2, episodes: EpisodeListPreviews.EPISODES),
            EpisodeSeason(id: 3, episodes: EpisodeListPreviews.EPISODES)
        ], hasNext: false))

        var hasFilters: Bool = false
        var error: Error? = .none

        func onViewMount() {}

        func refetch() async {
            await PreviewUtils.delay()
        }

        func fetchNextPage() async {
            await PreviewUtils.delay()
        }
    }

    static var previews: some View {
        NavigationStack {
            ShowEpisodesScreen(router: RouterMock()) {
                ViewModelMock()
            }
        }
    }
}
