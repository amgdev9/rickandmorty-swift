import SwiftUI

// MARK: - View
struct SectionButton: View {
    let title: String
    let subtitle: String
    var info: String? = .none
    var active: Bool? = .none
    var showBorder: Bool = true
    var onPress: (() -> Void)? = .none

    var body: some View {
        Button {
            guard let onPress = onPress else { return }
            onPress()
        } label: {
            container(showBorder: showBorder) {
                if let active = active {
                    Icon(name: active ? .radioActive : .radioInactive)
                }
                VStack(alignment: .leading, spacing: 0) {
                    Text(title, variant: .body17, weight: .semibold, color: .basicBlack)
                    Text(subtitle, variant: .body15, color: .subtitleGray)
                    if let info = info {
                        infoText(info)
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)
                if onPress != nil {
                    Icon(name: .chevronRight)
                        .padding(.trailing, 16)
                }
            }
        }
        .disabled(onPress == nil)
    }
}

// MARK: - Styles
extension SectionButton {
    func container<Content: View>(showBorder: Bool, @ViewBuilder content: @escaping () -> Content) -> some View {
        HStack(spacing: 16, content: content)
            .padding([.top, .bottom], 8.5)
            .padding(.leading, containerPaddingLeading())
            .frame(maxWidth: .infinity, alignment: .leading)
            .border(width: showBorder ? 1 : 0, edges: [.top, .bottom], color: .black20)
    }

    func infoText(_ text: String) -> some View {
        Text(text, variant: .tagline11, color: .graybaseGray1)
            .padding(.top, 5)
            .textCase(.uppercase)
    }

    func containerPaddingLeading() -> CGFloat {
        guard let active = active else { return 16 }
        return active ? 18 : 19
    }
}

// MARK: - Previews
struct SectionButtonPreviews: PreviewProvider {
    static var previews: some View {
        SectionButton(title: "Name", subtitle: "Give a name", active: true, onPress: {})
            .previewDisplayName("With active bullet")
        SectionButton(title: "S01E01", subtitle: "Pilot", info: "December 2, 2013", onPress: {})
            .previewDisplayName("With info")
        SectionButton(title: "Gender", subtitle: "Male")
            .previewDisplayName("Basic not pressable")
    }
}
