import SwiftUI

struct ContentView: View {

    @State private var currentTab: TabID = .character

    var body: some View {
        VStack(spacing: 0) {
            Color.white.ignoresSafeArea(edges: [.top])
            Tabs(currentTab: $currentTab)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
