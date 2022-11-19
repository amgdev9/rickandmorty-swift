import SwiftUI

// MARK: - View
struct CharacterList<Item: CharacterCardItem>: View {
    let state: ListState<Item>
    let onRefetch: @Sendable () async -> Void
    let onLoadNextPage: () async -> Void
    let onPress: (_ id: String) -> Void

    @State private var loadingNextPage = false
    @State private var loadingRefetch = false

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack {
            switch state {
            case .loading:
                ProgressView()
            case .error(let message):
                ErrorState(message: message, loading: loadingRefetch, onPress: handleRefetch)
            case .data(let items):
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
                    .refreshable(action: onRefetch)
                }
            }
        }
    }
}

// MARK: - Logic
extension CharacterList {
    @Sendable func handleRefetch() {
        loadingRefetch = true
        Task { @MainActor in
            await onRefetch()
            loadingRefetch = false
        }
    }

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
