import SafariServices
import UIKit

let client_id = "c10d736ee85e4d2aa6b44e7032a98009"
let redirect_uri = "asyncinsta://"

let loginURL = "https://api.instagram.com/oauth/authorize/?" +
    "client_id=" + client_id +
    "&redirect_uri=" + redirect_uri +
    "&response_type=token"

class ViewController: UIViewController, SFSafariViewControllerDelegate {

    @IBOutlet var loginButton: UIButton!

    var center = NSNotificationCenter.defaultCenter() //var for testing
    let url = NSURL(string: loginURL)!
    //login with Safari View Controller -- maybe clean this up so it stays hidden as per rizzle's blog post
    lazy var svc: SFSafariViewController = {
        return SFSafariViewController(URL: self.url)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 5
        center.addObserver(self, selector: "safariLoginComplete:", name: Notifications.CloseSafariViewController.rawValue, object: nil)
    }

    func safariLoginComplete(notification: NSNotification){
        //ensure we really have an auth token 
        guard let _ = NSUserDefaults.standardUserDefaults().stringForKey(Defaults.AuthToken.rawValue) else {
            return
        }
        self.svc.dismissViewControllerAnimated(true){
            self.performSegueWithIdentifier("UserIsLoggedIn", sender: nil)
        }

    }
    
    @IBAction func showLoginVC(sender:UIButton){
        svc.delegate = self
        presentViewController(svc, animated: true, completion: nil)
    }

    @IBAction func dontWantToLogin(sender: UIButton) {
        let alert = UIAlertController(title: "Too Bad", message: "This App Currently only support the Authenticated Instagram Information", preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "¯\\_(ツ)_/¯", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }

    // If someone presses the done button on the SafariViewController
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

}

