import SwiftUI

struct TabsNavigator: View {
    let mainContainer: MainContainer
    @State private var currentTab: TabItem.ID = .character

    func currentScreen() -> AnyView {
        switch currentTab {
        case .character:
            return AnyView(CharacterStack(mainContainer: mainContainer))
        case .location:
            return AnyView(LocationStack(mainContainer: mainContainer))
        case .episodes:
            return AnyView(ShowEpisodesScreen {
                mainContainer.showEpisodesViewModel
            })
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            currentScreen()
                .frame(maxHeight: .infinity)
                .ignoresSafeArea(edges: [.top])
            Tabs(currentTab: $currentTab)
        }
    }
}
