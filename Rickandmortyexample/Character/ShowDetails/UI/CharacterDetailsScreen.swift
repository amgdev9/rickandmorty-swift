import SwiftUI

struct CharacterDetailsScreen<ViewModel>: View where ViewModel: CharacterDetailsViewModel {
    @StateObject private var viewModel: ViewModel
    let router: CharacterDetailsScreenRouter

    @EnvironmentObject var i18n: I18N

    init(router: CharacterDetailsScreenRouter, viewModelFactory: @escaping () -> ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModelFactory())
        self.router = router
    }

    var body: some View {
        NavigationContainer(title: navigationTitle) {
            NetworkDataContainer(data: viewModel.character, onRefetch: viewModel.refetch) { character in
                ScrollView {
                    CharacterHeader(character: character)
                    VStack(alignment: .leading, spacing: 0) {
                        CharacterInfo(character: character, onPressLocation: router.gotoLocation)
                        Text(i18n.t("section/character-episodes"), variant: .body20, weight: .bold, color: .graybaseGray1)
                            .padding(.top, 39.5)
                            .padding(.bottom, 17)
                            .padding(.leading, 16)
                        Separator()
                        EpisodeList(episodes: character.episodes) { id in
                            router.gotoEpisode(id: id)
                        }
                        Separator()
                    }
                }
            }
            .onMount {
                viewModel.onViewMount(characterId: router.params.id)
            }
            .errorAlert($viewModel.error)
        }
    }

    var navigationTitle: String {
        guard case let .data(character) = viewModel.character else { return "" }

        return character.name
    }
}

// MARK: - Types
protocol CharacterDetailsScreenRouter {
    var params: CharacterDetailsScreenParams { get }

    func gotoLocation(id: String)
    func gotoEpisode(id: String)
}

struct CharacterDetailsScreenParams: Hashable {
    let id: String
}

extension CharacterDetails: CharacterHeaderData & CharacterInfoData {}

// MARK: - Previews
struct CharacterDetailsScreenPreviews: PreviewProvider {
    class RouterMock: CharacterDetailsScreenRouter {
        var params = CharacterDetailsScreenParams(id: "1")

        func gotoLocation(id: String) {}
        func gotoEpisode(id: String) {}
    }

    class ViewModelMock: CharacterDetailsViewModel {
        func onViewMount(characterId: String) {}
        func refetch() async {
            await PreviewUtils.delay()
        }

        var character: NetworkData<CharacterDetails> = .data(
            CharacterDetails.Mother.buildMock()
        )
        var error: Error? = .none
    }

    static var previews: some View {
        NavigationStack {
            CharacterDetailsScreen(router: RouterMock()) {
                ViewModelMock()
            }
        }
    }
}
