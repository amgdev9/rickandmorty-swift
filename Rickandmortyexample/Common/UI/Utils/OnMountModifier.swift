import SwiftUI

struct OnMountModifier: ViewModifier {
    @State private var mounted = false
    let handler: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear {
                if mounted { return }
                handler()
                mounted = true
            }
    }
}

extension View {
    func onMount(perform: @escaping () -> Void) -> some View {
        modifier(OnMountModifier(handler: perform))
    }
}
