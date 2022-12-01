import SwiftUI
import RealmSwift

@main
struct Main: SwiftUI.App {
    let mainContainer: MainContainer

    private func preloadDatabase() {
        do {
            let realm = try mainContainer.realmFactory.buildWithoutQueue()
            try RealmCharacterFilterRepository.preload(realm: realm)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    init() {
        registerProviderFactories()
        mainContainer = MainContainer()

        preloadDatabase()
    }

    var body: some Scene {
        WindowGroup {
            TabsNavigator(mainContainer: mainContainer)
        }
    }
}
