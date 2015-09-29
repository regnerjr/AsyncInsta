import UIKit

enum Notifications: String {
    case CloseSafariViewController
}
enum Defaults: String {
    case AuthToken
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var persistence = Persistence()
    var networking = Networking()

    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        guard let source = options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String  else {
            print("No Source App? This feels like an error for us, no-one else should be calling us")
            return true
        }
        if source == "com.apple.SafariViewService" { //safariViewController
            let center = NSNotificationCenter.defaultCenter()
            TokenURLParser.parse(url)
            center.postNotificationName(Notifications.CloseSafariViewController.rawValue, object: nil)
        }
        return true
    }

    //save CoreData when Terminating
    func applicationWillTerminate(application: UIApplication) {
        persistence.saveContext()
    }

}

struct TokenURLParser {
    static func parse(url: NSURL) {
        let comps = url.absoluteString.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "="))
        let auth_token = comps[1]
        NSUserDefaults.standardUserDefaults().setObject(auth_token, forKey: Defaults.AuthToken.rawValue)
    }
}