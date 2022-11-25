import SwiftUI

struct Header: View {
    let title: String
    let subtitle: String
    let info: String

    var body: some View {
        VStack(spacing: 0) {
            Text(info, variant: .caption11, color: .subtitleGray)
                .padding(.top, 20)
            Text(title, variant: .h2, color: .basicBlack)
            Text(subtitle, variant: .tagline13, color: .graybaseGray1)
                .textCase(.uppercase)
                .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
        .background(Color.graybaseGray6)
    }
}

// MARK: - Previews
struct HeaderPreviews: PreviewProvider {
    static var previews: some View {
        Header(title: "Rick Sanchez", subtitle: "Human", info: "Alive")
    }
}
