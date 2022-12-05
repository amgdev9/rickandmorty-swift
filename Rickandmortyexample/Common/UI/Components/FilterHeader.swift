import SwiftUI

// MARK: - View
struct FilterHeader: View {
    let onPressApply: () -> Void
    let onPressClear: () -> Void
    let clearDisabled: Bool

    @EnvironmentObject var i18n: I18N

    var body: some View {
        container {
            if !clearDisabled {
                TextButton(title: i18n.t("action/clear"), onPress: onPressClear)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Spacer().frame(maxWidth: .infinity)
            }
            title(i18n.t("routes/filter"))
            ActionButton(title: i18n.t("action/apply"), onPress: onPressApply)
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
        FilterHeader(onPressApply: {}, onPressClear: {}, clearDisabled: false)
            .previewDisplayName("Basic")
        FilterHeader(onPressApply: {}, onPressClear: {}, clearDisabled: true)
            .previewDisplayName("Without clear")
    }
}
