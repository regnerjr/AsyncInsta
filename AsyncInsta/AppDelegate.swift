import UIKit

enum Notifications: String {
    case CloseSafariViewController
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var persistence = Persistence()

    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        print("Open URL got Called")
        return true
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        // just making sure we send the notification when the URL is opened in SFSafariViewController
        print("Application Got Called to Open URL \(url)")
        if (sourceApplication == "com.apple.SafariViewService") {
            NSNotificationCenter.defaultCenter().postNotificationName(Notifications.CloseSafariViewController.rawValue, object: url)
            return true
        }
        return true
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        persistence.saveContext()
    }

}
