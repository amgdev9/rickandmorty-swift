import SwiftUI

class Router {
    let path: Binding<NavigationPath>

    init(path: Binding<NavigationPath>) {
        self.path = path
    }
}
