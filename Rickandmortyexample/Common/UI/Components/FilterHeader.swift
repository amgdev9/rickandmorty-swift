import SwiftUI

// MARK: - View
struct FilterHeader: View {
    let onPressApply: () -> Void
    let onPressClear: (() -> Void)?

    var body: some View {
        container {
            if let onPressClear = onPressClear {
                TextButton(title: String(localized: "action/clear"), onPress: onPressClear)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            title(String(localized: "routes/filter"))
            ActionButton(title: String(localized: "action/apply"), onPress: onPressApply)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

// MARK: - Styles
extension FilterHeader {
    func container<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        HStack(content: content)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
    }

    func title(_ value: String) -> some View {
        Text(value, variant: .body15, weight: .semibold, color: .basicBlack)
            .frame(maxWidth: .infinity)
    }
}

// MARK: - Previews
struct FilterHeaderPreviews: PreviewProvider {
    static var previews: some View {
        FilterHeader(onPressApply: {}, onPressClear: {})
    }
}
