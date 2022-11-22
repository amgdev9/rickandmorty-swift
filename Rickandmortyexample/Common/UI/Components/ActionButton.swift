import SwiftUI

// MARK: - View
struct ActionButton: View {
    let title: String
    let onPress: () -> Void

    var body: some View {
        Button(action: onPress) {
            Text(title, variant: .tagline13, color: .basicWhite)
                .textCase(.uppercase)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 12)
        .background(Color.primaryIndigo)
        .cornerRadius(14)
    }
}

// MARK: - Previews
struct ButtonPreviews: PreviewProvider {
    static var previews: some View {
        ActionButton(title: "Apply", onPress: {})
    }
}
