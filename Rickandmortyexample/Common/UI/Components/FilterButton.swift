import SwiftUI

// MARK: - View
struct FilterButton: View {
    let showDot: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if showDot { dot() }
                Text(String(localized: "actions/filter"), variant: .body17, weight: .semibold, color: .primaryIndigo)
            }
        }
    }
}

// MARK: - Styles
extension FilterButton {
    func dot() -> some View {
        Circle().frame(width: 12, height: 12).foregroundColor(.primaryIndigo)
    }
}

// MARK: - Previews
struct FilterButtonPreviews: PreviewProvider {
    static var previews: some View {
        FilterButton(showDot: false) {
            print("Pressed")
        }
        FilterButton(showDot: true) {
            print("Pressed")
        }
    }
}
