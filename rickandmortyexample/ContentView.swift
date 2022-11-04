import SwiftUI

struct EdgeBorder: Shape {

    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }

            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }

            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return self.width
                }
            }

            var h: CGFloat {
                switch edge {
                case .top, .bottom: return self.width
                case .leading, .trailing: return rect.height
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }
        return path
    }
}

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

struct ContentView: View {

    @State private var currentTab: TabID = .character

    var body: some View {
        VStack(spacing: 0) {
            Color.white.ignoresSafeArea(edges: [.top])
            HStack {
                TabItem(id: .character, title: "Character", icon: .character, currentTab: $currentTab).frame(maxWidth: .infinity)
                TabItem(id: .location, title: "Location", icon: .location, currentTab: $currentTab).frame(maxWidth: .infinity)
                TabItem(id: .episodes, title: "Episode", icon: .episodes, currentTab: $currentTab).frame(maxWidth: .infinity)
            }.frame(maxWidth: .infinity)
            .padding(.top, 4)
            .background(Color.tabsGray)
            .border(width: 1, edges: [.top], color: .black20)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
