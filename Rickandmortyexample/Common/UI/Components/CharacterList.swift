import SwiftUI

// MARK: - View
struct CharacterList: View {
    let state: ListState
    let onRefetch: @Sendable () async -> Void
    let onLoadNextPage: () -> Void
    let onPress: (_ id: String) -> Void

    var body: some View {
        VStack {
            switch state {
            case .loading: ProgressView()
            // TODO Error state in other component (and handle refreshing state)
            case .error(let error): Text(error.message, variant: .body17)
            case .data(let data):
                GeometryReader { geometry in
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(data.items, id: \.id) { item in
                                CharacterCard(item: item, action: onPress)
                                    .frame(maxWidth: geometry.size.width * 0.45)
                            }
                        }
                        if data.loadingNextPage { ProgressView() }
                        Color.clear
                            .frame(width: 0, height: 0, alignment: .bottom)
                            .onAppear(perform: onLoadNextPage)
                    }.refreshable(action: onRefetch)
                }
            }
        }
    }
}

// MARK: - Types
extension CharacterList {
    enum ListState {
        case loading
        case data(Data)
        case error(Error)
    }

    struct Data {
        let items: [CharacterCardItem]
        let loadingNextPage: Bool
    }

    struct Error {
        let message: String
        let refetching: Bool
    }
}

// MARK: - Previews
struct CharacterListPreviews: PreviewProvider {
    typealias Character = CharacterCardPreviews.Item

    static let characters = (1...10).map { i in
        Character(id: String(i), imageURL: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                  name: "Rick Sanchez", status: .alive)
    }

    static func onRefetch() async {
        try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
    }

    static var previews: some View {
        CharacterList(state: .loading, onRefetch: {}, onLoadNextPage: {}, onPress: {_ in })
            .previewDisplayName("Loading state")
        CharacterList(state: .data(CharacterList.Data(items: characters, loadingNextPage: false)), onRefetch: onRefetch, onLoadNextPage: {}, onPress: {_ in })
            .previewDisplayName("With data")
        CharacterList(state: .data(CharacterList.Data(items: characters, loadingNextPage: true)), onRefetch: onRefetch, onLoadNextPage: {}, onPress: {_ in })
            .previewDisplayName("With data and loading next page")
        CharacterList(state: .error(CharacterList.Error(message: "An error has happened!", refetching: false)), onRefetch: {}, onLoadNextPage: {}, onPress: {_ in })
            .previewDisplayName("Error state")
    }
}
