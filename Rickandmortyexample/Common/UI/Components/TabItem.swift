import SwiftUI

enum TabID: Int {
    case character
    case location
    case episodes
}

struct TabItem: View {
    let id: TabID
    let title: String
    let icon: IconName
    @Binding var currentTab: TabID

    var focused: Bool {
        currentTab == id
    }

    var body: some View {
        VStack(spacing: 2) {
            Icon(name: icon, variant: focused ? .filled : .outlined)
            Text(title, variant: .caption10, color: focused ? .primaryIndigo : .graybaseGray1)
        }.onTapGesture {
            currentTab = id
        }
    }
}
