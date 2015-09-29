import SwiftyJSON
import AsyncDisplayKit
import Alamofire
import SafariServices

import UIKit


let loginURL = "https://api.instagram.com/oauth/authorize/?client_id=c10d736ee85e4d2aa6b44e7032a98009&redirect_uri=https://johnregner.com/AsyncInsta&response_type=code"

class ViewController: UIViewController, SFSafariViewControllerDelegate {

    @IBOutlet var loginButton: UIButton!

    let url = NSURL(string: loginURL)!
    lazy var svc: SFSafariViewController = { return SFSafariViewController(URL: self.url)}()

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: ":safariLogin:", name: Notifications.CloseSafariViewController.rawValue, object: nil)
    }

    func safariLogin(notification: NSNotification){

        let url = notification.object as! NSURL
        print("GOT URL: \(url)")
        self.svc.dismissViewControllerAnimated(true, completion: {print("dismissed SVC in Notification Handler")})
    }


    @IBAction func showLoginVC(sender:UIButton){
        svc.delegate = self
        presentViewController(svc, animated: true, completion: {print("Completed showing Safari View Controller")})
    }

    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}

