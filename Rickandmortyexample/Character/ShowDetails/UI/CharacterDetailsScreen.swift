import SwiftUI

struct CharacterDetailsScreen<ViewModel>: View where ViewModel: CharacterDetailsViewModel {
    @StateObject private var viewModel: ViewModel
    let router: CharacterDetailsScreenRouter

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
                        Text(String(localized: "section/character-episodes"), variant: .body20, weight: .bold, color: .graybaseGray1)
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
        }
    }

    var navigationTitle: String {
        if case let .data(character) = viewModel.character {
            return character.name
        }

        return ""
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
        func refetch() async {
            do {
                try await Task.sleep(nanoseconds: 2_000_000_000)
            } catch {}
        }

        var character: NetworkData<CharacterDetails> = .data(
            CharacterDetails.Builder()
                .set(id: "1")
                .set(name: "Rick Sanchez")
                .set(imageURL: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
                .set(status: .alive)
                .set(species: "Human")
                .set(gender: .male)
                .set(origin: CharacterLocation(id: "1", name: "Earth (C-137)"))
                .set(type: .none)
                .set(location: CharacterLocation(id: "2", name: "Earth (Replacement Dimension)"))
                .set(episodes: EpisodeListPreviews.EPISODES)
                .build()
        )
    }

    static var previews: some View {
        NavigationStack {
            CharacterDetailsScreen(router: RouterMock()) {
                ViewModelMock()
            }
        }
    }
}
