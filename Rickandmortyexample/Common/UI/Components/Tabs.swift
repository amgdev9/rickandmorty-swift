import SwiftUI

// MARK: - View
struct Tabs: View {
    @Binding var currentTab: TabItem.ID

    var body: some View {
        container {
            item(id: .character, currentTab: $currentTab)
            item(id: .location, currentTab: $currentTab)
            item(id: .episodes, currentTab: $currentTab)
        }
    }
}

// MARK: - Styles
extension Tabs {
    func item(id: TabItem.ID, currentTab: Binding<TabItem.ID>) -> some View {
        TabItem(id: id, currentTab: $currentTab)
            .frame(maxWidth: .infinity)
    }

    func container<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        HStack(alignment: .lastTextBaseline, content: content)
            .frame(maxWidth: .infinity)
            .padding(.top, 4)
            .background(Color.tabsGray)
            .border(width: 1, edges: [.top], color: .black20)
    }
}

// MARK: - Previews
struct TabsPreviews: PreviewProvider {
    static var previews: some View {
        Tabs(currentTab: .constant(.character))
    }
}
