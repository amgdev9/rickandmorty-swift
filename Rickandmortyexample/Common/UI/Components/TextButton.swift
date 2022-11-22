import SwiftUI

// MARK: - View
struct TextButton: View {
    let title: String
    let onPress: () -> Void

    var body: some View {
        Button(action: onPress) {
            Text(title, variant: .body17, color: .primaryIndigo)
        }
    }
}

// MARK: - Previews
struct TextButtonPreviews: PreviewProvider {
    static var previews: some View {
        TextButton(title: "Clear", onPress: {})
    }
}
