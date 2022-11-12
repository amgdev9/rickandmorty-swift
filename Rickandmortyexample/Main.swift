import SwiftUI

@main
struct Main: App {
    init() {
        registerProviderFactories()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
