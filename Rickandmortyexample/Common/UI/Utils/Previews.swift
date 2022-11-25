import SwiftUI

extension PreviewProvider {
    @Sendable static func delay() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
    }
}
