import SwiftUI

// MARK: - View
struct BottomDetectorScrollView<Content: View>: View {
    @ViewBuilder let content: () -> Content
    let onBottomReached: () -> Void

    let spaceName = "scroll"

    @State var wholeSize: CGSize = .zero
    @State var scrollViewSize: CGSize = .zero
    @State private var hasReachedBottom = false

    var body: some View {
        ChildSizeReader(size: $wholeSize) {
            ScrollView {
                ChildSizeReader(size: $scrollViewSize) {
                    content()
                        .background(
                            GeometryReader { proxy in
                                Color.clear.preference(
                                    key: ViewOffsetKey.self,
                                    value: -1 * proxy.frame(in: .named(spaceName)).origin.y
                                )
                            }
                        )
                        .onPreferenceChange(
                            ViewOffsetKey.self,
                            perform: onScroll
                        )
                }
            }
            .coordinateSpace(name: spaceName)
        }
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

// MARK: - Logic
extension BottomDetectorScrollView {
    func onScroll(value: CGFloat) {
        if value >= scrollViewSize.height - wholeSize.height {
            if hasReachedBottom { return }
            hasReachedBottom = true
            onBottomReached()
        } else {
            hasReachedBottom = false
        }
    }
}
