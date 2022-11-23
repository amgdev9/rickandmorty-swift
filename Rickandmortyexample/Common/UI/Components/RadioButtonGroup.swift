import SwiftUI

// MARK: - View
struct RadioButtonGroup<T: LocalizedEnum & Equatable & Hashable>: View {
    let title: String
    let values: [T]
    @Binding var value: T?

    var body: some View {
        VStack {
            titleText(title)
            Separator()
            ForEach(values, id: \.self) { targetValue in
                RadioButton(value: $value, targetValue: targetValue)
                if let lastValue = values.last, targetValue != lastValue {
                    Separator()
                        .offset(CGSize(width: 56, height: 0))
                }
            }
            Separator()
        }
    }
}

// MARK: - Styles
extension RadioButtonGroup {
    func titleText(_ text: String) -> some View {
        Text(text, variant: .body15, color: .gray40)
            .padding(.bottom, 8.5)
            .padding(.leading, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Previews
struct RadioButtonGroupPreviews: PreviewProvider {
    static var previews: some View {
        RadioButtonGroup<Character.Status>(title: "Status", values: [.alive, .dead, .unknown], value: .constant(.alive))
    }
}
