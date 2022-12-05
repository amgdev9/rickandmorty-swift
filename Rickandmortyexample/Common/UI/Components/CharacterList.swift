import SwiftUI

// MARK: - View
struct CharacterList<Item: CharacterCardItem>: View {
    let characters: [Item]
    let onPress: (_ id: String) -> Void

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    private let widthPercentage = 0.42

    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(characters, id: \.id) { character in
                CharacterCard(item: character, action: onPress)
                    .frame(maxWidth: UIScreen.width * widthPercentage)
            }
        }
    }
}

// MARK: - Previews
struct CharacterListPreviews: PreviewProvider {
    static let characters = (1...10).map { i in
        CharacterSummary.Mother.build(id: String(i))
    }

    static var previews: some View {
        CharacterList(characters: characters, onPress: {_ in })
    }
}
