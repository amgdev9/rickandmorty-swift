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
                Text(character.status.localized(), variant: .caption11, color: .subtitleGray)
                    .padding(.top, 20)
                Text(character.name, variant: .h2, color: .basicBlack)
                Text(character.species, variant: .tagline13, color: .graybaseGray1)
                    .textCase(.uppercase)
                    .padding(.bottom, 20)
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
