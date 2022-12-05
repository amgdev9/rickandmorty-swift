import SwiftUI

// MARK: - View
struct CharacterCard<Item: CharacterCardItem>: View {
    let item: Item
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
        AsyncImage(url: URL(string: url), content: { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, minHeight: 140, maxHeight: 140)
                .clipped()
        }, placeholder: {
            Color.white
                .frame(maxWidth: .infinity, minHeight: 140, maxHeight: 140)
        }).frame(maxWidth: .infinity, minHeight: 140, maxHeight: 140)
    }

    func content<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 0, content: content)
            .padding(12)
    }

    func name(_ name: String) -> some View {
        Text(name, variant: .body17, weight: .semibold)
            .multilineTextAlignment(.leading)
            .frame(height: 44, alignment: .top)
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
    static var previews: some View {
        CharacterCard(item: CharacterSummary.Mother.build(id: "1")) { _ in }.frame(width: 163)
    }
}
