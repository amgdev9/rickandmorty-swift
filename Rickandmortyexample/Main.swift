import SwiftUI
import RealmSwift

@main
struct Main: SwiftUI.App {
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
