import SwiftUI

// MARK: - View
struct TabItem: View {
    let id: ID
    let data: Data
    @Binding var currentTab: ID

    init(id: ID, currentTab: Binding<ID>) {
        self.id = id

        let data = TabItem.data[id]
        assert(data != nil, "TabItem data not configured")
        self.data = data!

        self._currentTab = currentTab
    }

    var body: some View {
        container {
            Icon(name: data.icon, variant: focused ? .filled : .outlined)
            Text(String(localized: data.titleKey), variant: .caption10,
                 color: focused ? .primaryIndigo : .graybaseGray1)
        }.onTapGesture { onPress() }
    }
}

// MARK: - Styles
extension TabItem {
    func container<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        VStack(spacing: 2, content: content)
    }
}

// MARK: - Logic
extension TabItem {
    var focused: Bool {
        currentTab == id
    }

    func onPress() {
        currentTab = id
    }
}

// MARK: - Constants
extension TabItem {
    static let data: [ID: Data] = [
        .character: Data(titleKey: "enums/TabItemID/character", icon: .character),
        .location: Data(titleKey: "enums/TabItemID/location", icon: .location),
        .episodes: Data(titleKey: "enums/TabItemID/episodes", icon: .episodes)
    ]
}

// MARK: - Previews
struct TabItemPreviews: PreviewProvider {
    static var previews: some View {
        VStack {
            TabItem(id: .character, currentTab: .constant(.character))
            TabItem(id: .character, currentTab: .constant(.location))
            TabItem(id: .location, currentTab: .constant(.character))
            TabItem(id: .episodes, currentTab: .constant(.character))
        }
    }
}

// MARK: - Types
extension TabItem {
    enum ID: Int {
        case character
        case location
        case episodes
    }

    class Data {
        let titleKey: String.LocalizationValue
        let icon: Icon.Name

        init(titleKey: String.LocalizationValue, icon: Icon.Name) {
            self.titleKey = titleKey
            self.icon = icon
        }
    }
}
