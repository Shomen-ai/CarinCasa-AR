import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.overrideUserInterfaceStyle = .light
        window?.rootViewController =  MainTabBarController()
        window?.makeKeyAndVisible()
        return true
    }
}
