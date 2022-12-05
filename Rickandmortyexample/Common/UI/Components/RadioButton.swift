import SwiftUI

// MARK: - View
struct RadioButton<T: LocalizedEnum & Equatable>: View {
    @Binding var value: T?
    let targetValue: T

    var body: some View {
        Button(action: handlePress) {
            let active = value == targetValue
            container(active: active) {
                Icon(name: active ? .radioActive : .radioInactive)
                    .padding(.vertical, active ? 0 : 1)
                    .padding(.trailing, active ? 0 : 1)
                Text(targetValue.localized(), variant: .body17, color: .basicBlack)
            }
        }
    }
}

// MARK: - Styles
extension RadioButton {
    func container<Content: View>(active: Bool, @ViewBuilder content: @escaping () -> Content) -> some View {
        HStack(spacing: 15, content: content)
            .padding([.top, .bottom], 9.5)
            .padding(.leading, active ? 18 : 19)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Logic
extension RadioButton {
    func handlePress() {
        if value != targetValue {
            value = targetValue
        } else {
            value = .none
        }
    }
}

// MARK: - Previews
struct RadioButtonPreviews: PreviewProvider {
    static var previews: some View {
        RadioButton(value: .constant(Character.Status.alive), targetValue: .alive)
            .previewDisplayName("Active")
        RadioButton(value: .constant(Character.Status.alive), targetValue: .unknown)
            .previewDisplayName("Inactive")
    }
}
