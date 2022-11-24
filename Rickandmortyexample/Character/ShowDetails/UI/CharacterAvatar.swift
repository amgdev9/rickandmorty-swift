import SwiftUI

struct CharacterAvatar: View {
    let url: String

    var body: some View {
        AsyncImage(url: URL(string: url), content: { image in
            image
                .resizable()
                .frame(width: 130, height: 130)
                .clipped()
        }, placeholder: {
            Color.white
                .frame(width: 130, height: 130)
        })
        .cornerRadius(65)
        .overlay(RoundedRectangle(cornerRadius: 65).stroke(Color.graybaseGray6, lineWidth: 5))
            .padding(.top, 19)
    }
}

// MARK: - Previews
struct CharacterAvatarPreviews: PreviewProvider {
    static var previews: some View {
        CharacterAvatar(url: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
    }
}
