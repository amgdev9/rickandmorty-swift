import SwiftUI
import RealmSwift

@main
struct Main: SwiftUI.App {
    let mainContainer: MainContainer

    @StateObject var i18n = I18N()

    init() {
        registerProviderFactories()
        mainContainer = MainContainer()

        let preloader = mainContainer.realm.realmPreloader
        preloader.preload()
    }

    var body: some Scene {
        WindowGroup {
            TabsNavigator(mainContainer: mainContainer)
                .environmentObject(i18n)
        }
    }
}
