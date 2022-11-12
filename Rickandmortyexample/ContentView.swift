import SwiftUI

struct ContentView: View {
    @State private var currentTab: TabItem.ID = .character

    var body: some View {
        VStack(spacing: 0) {
            Color.white.ignoresSafeArea(edges: [.top])
            Tabs(currentTab: $currentTab)
        }
    }
}

struct ContentViewPreviews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
