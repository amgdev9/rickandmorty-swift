import SwiftUI

struct LocationDetailsScreen<ViewModel>: View where ViewModel: LocationDetailsViewModel {
    @StateObject private var viewModel: ViewModel
    let router: LocationDetailsScreenRouter

    @EnvironmentObject var i18n: I18N

    init(router: LocationDetailsScreenRouter, viewModelFactory: @escaping () -> ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModelFactory())
        self.router = router
    }

    var body: some View {
        NavigationContainer(title: navigationTitle) {
            NetworkDataContainer(data: viewModel.location, onRefetch: viewModel.refetch) { location in
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Header(title: location.name, subtitle: location.dimension, info: location.type)
                        Text(i18n.t("section/residents"), variant: .body20, weight: .bold, color: .graybaseGray1)
                            .padding(.leading, 16)
                            .padding(.top, 20)
                            .padding(.bottom, 10)
                        CharacterList(characters: location.residents, onPress: router.gotoCharacter)
                    }
                }
            }
        }
    }

    var navigationTitle: String {
        if case let .data(location) = viewModel.location {
            return location.name
        }

        return ""
    }
}

// MARK: - Types
protocol LocationDetailsScreenRouter {
    var params: LocationDetailsScreenParams { get }

    func gotoCharacter(id: String)
}

struct LocationDetailsScreenParams: Hashable {
    let id: String
}

// MARK: - Previews
struct LocationDetailsScreenPreviews: PreviewProvider {
    class RouterMock: LocationDetailsScreenRouter {
        var params = LocationDetailsScreenParams(id: "1")

        func gotoCharacter(id: String) {}
    }

    static let residents = (1...10).map { i in
        CharacterSummary.Builder()
            .set(id: String(i))
            .set(imageURL: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
            .set(name: "Rick Sanchez")
            .set(status: .alive)
            .build()
    }

    class ViewModelMock: LocationDetailsViewModel {
        var location: NetworkData<LocationDetail> = .data(LocationDetail.Builder()
            .set(id: "1")
            .set(name: "Earth (Replacement Dimension)")
            .set(type: "Planet")
            .set(dimension: "Replacement Dimension")
            .set(residents: residents)
            .build()
        )

        func refetch() async {
            await PreviewUtils.delay()
        }
    }

    static var previews: some View {
        NavigationStack {
            LocationDetailsScreen(router: RouterMock()) {
                ViewModelMock()
            }
        }
    }
}
