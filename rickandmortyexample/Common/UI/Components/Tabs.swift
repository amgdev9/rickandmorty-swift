import SwiftUI

struct Tabs: View {
    @Binding var currentTab: TabID

    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            TabItem(id: .character, title: "Character", icon: .character, currentTab: $currentTab)
                .frame(maxWidth: .infinity)
            TabItem(id: .location, title: "Location", icon: .location, currentTab: $currentTab)
                .frame(maxWidth: .infinity)
            TabItem(id: .episodes, title: "Episode", icon: .episodes, currentTab: $currentTab)
                .frame(maxWidth: .infinity)
        }.frame(maxWidth: .infinity)
        .padding(.top, 4)
        .background(Color.tabsGray)
        .border(width: 1, edges: [.top], color: .black20)
    }
}


struct Tabs_Previews: PreviewProvider {
    static var previews: some View {
        Tabs(currentTab: .constant(.character))
    }
}
