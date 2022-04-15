import SwiftUI

@main
struct MyApp: App {
    
    private let persistentStore = PersistenceStore.shared
    private let activeTimer = ActiveTimer.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(persistentStore)
                .environmentObject(activeTimer)
        }
    }
}
