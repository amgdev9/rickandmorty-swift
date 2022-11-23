import SwiftUI

struct NavigationContainer<Content>: View where Content: View {
    let title: String
    var color: Color
    @ViewBuilder let content: () -> Content

    init(title: String, color: Color = .gray92, content: @escaping () -> Content) {
        self.title = title
        self.color = color
        self.content = content
        configureNavBarStyles()
    }

    var body: some View {
        VStack(content: content)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    titleText(title)
                }
            }
    }
}

// MARK: - Styles
extension NavigationContainer {
    func configureNavBarStyles() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.backgroundColor = UIColor(color)
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }

    func titleText(_ text: String) -> some View {
        Text(text, variant: .body15, weight: .semibold, color: .basicBlack)
    }
}

// MARK: - Previews
struct NavigationContainerPreviews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NavigationContainer(title: "Name") {
                Text("Hello World!", variant: .body15)
            }
        }
    }
}
