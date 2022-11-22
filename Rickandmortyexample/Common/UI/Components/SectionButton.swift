import SwiftUI

// MARK: - View
struct SectionButton: View {
    let title: String
    let subtitle: String
    let active: Bool
    let onPress: () -> Void

    var body: some View {
        Button(action: onPress) {
            container(active: active) {
                Icon(name: active ? .radioActive : .radioInactive)
                VStack(alignment: .leading, spacing: 0) {
                    Text(title, variant: .body17, weight: .semibold, color: .basicBlack)
                    Text(subtitle, variant: .body15, color: .subtitleGray)
                }.frame(maxWidth: .infinity, alignment: .leading)
                Icon(name: .chevronRight)
                    .padding(.trailing, 16)
            }
        }
    }
}

// MARK: - Styles
extension SectionButton {
    func container<Content: View>(active: Bool, @ViewBuilder content: @escaping () -> Content) -> some View {
        HStack(spacing: 16, content: content)
            .padding([.top, .bottom], 8.5)
            .padding(.leading, active ? 18 : 19)
            .frame(maxWidth: .infinity, alignment: .leading)
            .border(width: 1, edges: [.top, .bottom], color: .black20)
    }
}

// MARK: - Previews
struct SectionButtonPreviews: PreviewProvider {
    static var previews: some View {
        SectionButton(title: "Name", subtitle: "Give a name", active: true, onPress: {})
    }
}
