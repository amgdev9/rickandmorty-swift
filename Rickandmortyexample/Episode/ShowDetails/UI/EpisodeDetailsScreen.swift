import SwiftUI

struct EpisodeDetailsScreen<ViewModel>: View where ViewModel: EpisodeDetailsViewModel {
    @StateObject private var viewModel: ViewModel
    let router: EpisodeDetailsScreenRouter

    @EnvironmentObject var i18n: I18N

    init(router: EpisodeDetailsScreenRouter, viewModelFactory: @escaping () -> ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModelFactory())
        self.router = router
    }

    var body: some View {
        NavigationContainer(title: navigationTitle) {
            NetworkDataContainer(data: viewModel.episode, onRefetch: viewModel.refetch) { episode in
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Header(
                            title: episode.name,
                            subtitle: episode.seasonID,
                            info: i18n.tDate(episode.date, format: "dateformat/MMMM d, yyyy")
                        )
                        Text(i18n.t("section/characters"), variant: .body20, weight: .bold, color: .graybaseGray1)
                            .padding(.leading, 16)
                            .padding(.top, 20)
                            .padding(.bottom, 10)
                        CharacterList(characters: episode.characters, onPress: router.gotoCharacter)
                    }
                }
            }
            .onMount {
                viewModel.onViewMount(episodeId: router.params.id)
            }
            .errorAlert($viewModel.error)
        }
    }

    var navigationTitle: String {
        guard case let .data(episode) = viewModel.episode else { return "" }

        return episode.name
    }
}

// MARK: - Types
protocol EpisodeDetailsScreenRouter {
    var params: EpisodeDetailsScreenParams { get }

    func gotoCharacter(id: String)
}

struct EpisodeDetailsScreenParams: Hashable {
    let id: String
}

// MARK: - Previews
struct EpisodeDetailsScreenPreviews: PreviewProvider {
    class RouterMock: EpisodeDetailsScreenRouter {
        var params = EpisodeDetailsScreenParams(id: "1")

        func gotoCharacter(id: String) {}
    }

    class ViewModelMock: EpisodeDetailsViewModel {
        var error: Error? = .none
        var episode = NetworkData.data(EpisodeDetail.Mother.build(id: "1"))

        func onViewMount(episodeId: String) {}
        func refetch() async {
            await PreviewUtils.delay()
        }
    }

    static var previews: some View {
        NavigationStack {
            EpisodeDetailsScreen(router: RouterMock()) {
                ViewModelMock()
            }
        }
    }
}
