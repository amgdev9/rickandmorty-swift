import SwiftUI

struct LocationCard: View {
    let location: LocationSummary
    let onPress: (_ id: String) -> Void

    var body: some View {
        Button {
            onPress(location.id)
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                Text(location.type, variant: .caption11, color: .subtitleGray)
                Text(location.name, variant: .body17, weight: .semibold, color: .basicBlack)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 44, alignment: .topLeading)
            }
            .padding(12)
            .cornerRadius(8)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.graybaseGray5, lineWidth: 1)
            }
        }
    }
}

// MARK: - Previews
struct LocationCardPreviews: PreviewProvider {
    static let location = LocationSummary.Builder()
        .set(id: "1")
        .set(name: "Earth (C-137)")
        .set(type: "Planet")
        .build()

    static var previews: some View {
        LocationCard(location: location, onPress: { _ in })
            .frame(width: 160)
    }
}
