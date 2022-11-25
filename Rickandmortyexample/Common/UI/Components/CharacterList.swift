import SwiftUI

// MARK: - View
struct CharacterList<Item: CharacterCardItem>: View {
    let characters: [Item]
    let onPress: (_ id: String) -> Void

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(characters, id: \.id) { character in
                CharacterCard(item: character, action: onPress)
                    .frame(maxWidth: UIScreen.width * 0.42)
            }
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
        try? await Task.sleep(nanoseconds: 2_000_000_000)
    }

    static var previews: some View {
        CharacterList(characters: characters, onPress: {_ in })
    }
}
