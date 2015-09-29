//import SwiftyJSON
//import AsyncDisplayKit
//import Alamofire
import SafariServices

import UIKit


let loginURL = "https://api.instagram.com/oauth/authorize/?client_id=c10d736ee85e4d2aa6b44e7032a98009&redirect_uri=asyncinsta://&response_type=token"


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
        center.addObserver(self, selector: "safariLoginComplete:", name: Notifications.CloseSafariViewController.rawValue, object: nil)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("ViewController View Will Appear")
    }

    func safariLoginComplete(notification: NSNotification){
        //ensure we really have an auth token 
        guard let _ = NSUserDefaults.standardUserDefaults().stringForKey(Defaults.AuthToken.rawValue) else {
            // crap no token!
            return
        }
        self.svc.dismissViewControllerAnimated(true, completion: { [weak self] in
            print("dismissed SVC in Notification Handler")
            self?.performSegueWithIdentifier("UserIsLoggedIn", sender: nil)
        })
        loginButton.hidden = true

    }
    
    

    @IBAction func showLoginVC(sender:UIButton){
        svc.delegate = self
        presentViewController(svc, animated: true, completion: {print("Completed showing Safari View Controller")})
    }

    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

}

