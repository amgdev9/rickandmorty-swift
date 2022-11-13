import SwiftUI

struct TabsNavigator: View {
    let mainContainer: MainContainer
    @State private var currentTab: TabItem.ID = .character

    var body: some View {
        VStack(spacing: 0) {
            ShowCharactersScreen {
                mainContainer.showCharactersViewModel
            }
                .frame(maxHeight: .infinity)
                .ignoresSafeArea(edges: [.top])
            Tabs(currentTab: $currentTab)
        }
    }
}
