import SwiftUI

// MARK: - View
struct CharacterList<Item: CharacterCardItem>: View {
    let state: NetworkData<[Item]>
    let onRefetch: @Sendable () async -> Void
    let onLoadNextPage: () async -> Void
    let onPress: (_ id: String) -> Void

    @State private var loadingNextPage = false

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NetworkDataContainer(data: state, onRefetch: onRefetch) { items in
            GeometryReader { proxy in
                BottomDetectorScrollView {
                    VStack {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(items, id: \.id) { item in
                                CharacterCard(item: item, action: onPress)
                                    .frame(maxWidth: proxy.size.width * 0.42)
                            }
                        }
                        if loadingNextPage { ProgressView().padding(16) }
                    }
                } onBottomReached: {
                    handleLoadNextPage()
                }
            }
        }
    }
}

// MARK: - Logic
extension CharacterList {
    func handleLoadNextPage() {
        if loadingNextPage { return }
        loadingNextPage = true
        Task { @MainActor in
            await onLoadNextPage()
            loadingNextPage = false
        }
    }
}

// MARK: - Previews
struct CharacterListPreviews: PreviewProvider {
    typealias Character = CharacterCardPreviews.Item

    static let characters = (1...10).map { i in
        Character(id: String(i), imageURL: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                  name: "Rick Sanchez", status: .alive)
    }

    @Sendable static func delay() async {
        try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
    }

    static var previews: some View {
        CharacterList<CharacterCardPreviews.Item>(state: .loading, onRefetch: delay,
                                                  onLoadNextPage: delay, onPress: {_ in })
            .previewDisplayName("Loading state")
        CharacterList(state: .data(characters),
                      onRefetch: delay, onLoadNextPage: delay, onPress: {_ in })
            .previewDisplayName("With data")
        CharacterList<CharacterCardPreviews.Item>(state: .error("An error has happened!"),
                                                  onRefetch: delay, onLoadNextPage: delay, onPress: {_ in })
            .previewDisplayName("Error state")
    }
}
