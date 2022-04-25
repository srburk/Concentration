import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return AppDelegate.orientationLock
        }
}

@main
struct MyApp: App {
    
    private let persistentStore = PersistenceStore.shared
    private let activeTimer = ActiveTimer.shared
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(persistentStore)
                .environmentObject(activeTimer)
        }
    }
}
