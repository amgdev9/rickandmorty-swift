import SwiftUI

struct CharacterHeader<Character: CharacterHeaderData>: View {
    let character: Character

    @EnvironmentObject var i18n: I18N

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                backgroundImage()
                Color.graybaseGray6
            }
            VStack(spacing: 0) {
                CharacterAvatar(url: character.imageURL)
                Header(title: character.name, subtitle: character.species, info: i18n.tEnum(character.status))
            }
        }
    }
}

// MARK: - Styles
extension CharacterHeader {
    func backgroundImage() -> some View {
        Image("CharacterBackground")
            .resizable()
            .scaledToFill()
            .frame(height: 84)
    }
}

// MARK: - Types
protocol CharacterHeaderData {
    var imageURL: String { get }
    var status: Character.Status { get }
    var name: String { get }
    var species: String { get }
}
