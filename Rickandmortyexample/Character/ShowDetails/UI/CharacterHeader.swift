import SwiftUI

struct CharacterHeader<Character: CharacterHeaderData>: View {
    let character: Character

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Image("CharacterBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 84)
                Color.graybaseGray6
            }
            VStack(spacing: 0) {
                CharacterAvatar(url: character.imageURL)
                Header(title: character.name, subtitle: character.species, info: character.status.localized())
            }
        }
    }
}

// MARK: - Types
protocol CharacterHeaderData {
    var imageURL: String { get }
    var status: Character.Status { get }
    var name: String { get }
    var species: String { get }
}
