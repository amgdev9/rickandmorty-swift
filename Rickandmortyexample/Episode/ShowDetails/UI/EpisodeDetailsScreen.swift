import SwiftUI

struct EpisodeDetailsScreen<ViewModel>: View where ViewModel: EpisodeDetailsViewModel {
    @StateObject private var viewModel: ViewModel
    let router: EpisodeDetailsScreenRouter

    init(router: EpisodeDetailsScreenRouter, viewModelFactory: @escaping () -> ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModelFactory())
        self.router = router
    }

    var body: some View {
        NavigationContainer(title: navigationTitle) {
            NetworkDataContainer(data: viewModel.episode, onRefetch: viewModel.refetch) { episode in
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Header(title: episode.name, subtitle: episode.id, info: episode.date.formatted(format: "dateformat/MMMM dd, yyyy"))
                        Text(String(localized: "section/characters"), variant: .body20, weight: .bold, color: .graybaseGray1)
                            .padding(.leading, 16)
                            .padding(.top, 20)
                            .padding(.bottom, 10)
                        CharacterList(characters: episode.characters, onPress: router.gotoCharacter)
                    }
                }
            }
        }
    }

    var navigationTitle: String {
        if case let .data(episode) = viewModel.episode {
            return episode.name
        }

        return ""
    }
}

// MARK: - Types
protocol EpisodeDetailsScreenRouter {
    func gotoCharacter(id: String)
}

// MARK: - Previews
struct EpisodeDetailsScreenPreviews: PreviewProvider {
    class RouterMock: EpisodeDetailsScreenRouter {
        func gotoCharacter(id: String) {}
    }

    static let characters = (1...10).map { i in
        CharacterSummary.Builder()
            .set(id: String(i))
            .set(imageURL: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
            .set(name: "Rick Sanchez")
            .set(status: .alive)
            .build()
    }

    class ViewModelMock: EpisodeDetailsViewModel {
        var episode: NetworkData<EpisodeDetail> = .data(EpisodeDetail.Builder()
            .set(id: "S01E04")
            .set(name: "M. Night Shaym-Aliens!")
            .set(date: Date())
            .set(characters: characters)
            .build()
        )

        func refetch() async {
            await EpisodeDetailsScreenPreviews.delay()
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
