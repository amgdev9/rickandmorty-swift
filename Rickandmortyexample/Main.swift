import SwiftUI

@main
struct Main: App {
    let mainContainer: MainContainer

    init() {
        registerProviderFactories()
        mainContainer = MainContainer()
    }

    var body: some Scene {
        WindowGroup {
            TabsNavigator(mainContainer: mainContainer)
        }
    }
}
