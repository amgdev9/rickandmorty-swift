import SwiftUI

struct Separator: View {
    var body: some View {
        Divider().background(Color.black20)
    }
}

// MARK: - Previews
struct SeparatorPreviews: PreviewProvider {
    static var previews: some View {
        Separator()
    }
}
