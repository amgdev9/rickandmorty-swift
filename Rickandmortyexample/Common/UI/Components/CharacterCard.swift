import SwiftUI

// MARK: - View
struct CharacterCard: View {
    let item: CharacterCardItem
    let action: (_ id: String) -> Void

    var body: some View {
        Button {
            action(item.id)
        } label: {
            container {
                image(url: item.imageURL)
                content {
                    status(item.status)
                    name(item.name)
                }
            }
        }
    }
}

// MARK: - Styles
extension CharacterCard {
    func container<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 0, content: content)
            .cornerRadius(8)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.graybaseGray5, lineWidth: 1)
            }
    }

    func image(url: String) -> some View {
        AsyncImage(url: URL(string: url)) { data in
            data.image?
                .resizable()
                .scaledToFit()
                .frame(height: 140)
        }.frame(height: 140)
    }

    func content<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 0, content: content)
            .padding(12)
            .padding(.bottom, 20)
    }

    func name(_ name: String) -> some View {
        Text(name, variant: .body17, weight: .semibold)
    }

    func status(_ status: Character.Status) -> some View {
        Text(status.localized(), variant: .caption11, color: .additionalText)
    }
}

// MARK: - Types
protocol CharacterCardItem {
    var id: String { get }
    var imageURL: String { get }
    var name: String { get }
    var status: Character.Status { get }
}

// MARK: - Previews
struct CharacterCardPreviews: PreviewProvider {
    struct Item: CharacterCardItem {
        let id: String
        let imageURL: String
        let name: String
        let status: Character.Status
    }

    static let item = Item(id: "1", imageURL: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                           name: "Rick Sanchez", status: .alive)

    static var previews: some View {
        CharacterCard(item: item) { id in
            print("Pressed", id)
        }
    }
}
