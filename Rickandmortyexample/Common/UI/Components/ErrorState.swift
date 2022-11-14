import SwiftUI

// MARK: - View
struct ErrorState: View {
    let message: String
    let loading: Bool
    let onPress: () -> Void

    var body: some View {
            container {
                Text(message, variant: .body17)
                ZStack {
                    if loading {
                        ProgressView()
                    } else {
                        Button(String(localized: "action/try-again"), action: onPress)
                    }
                }
            }
    }
}

// MARK: - Styles
extension ErrorState {
    func container<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        VStack(spacing: 16, content: content)
            .padding(24)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            .shadow(color: .graybaseGray1, radius: 2.25)
    }
}

// MARK: - Previews
struct ErrorStatePreviews: PreviewProvider {
    static var previews: some View {
        ErrorState(message: "Unexpected error!", loading: false, onPress: {})
            .previewDisplayName("Basic")
        ErrorState(message: "Unexpected error!", loading: true, onPress: {})
            .previewDisplayName("Loading state")
    }
}
