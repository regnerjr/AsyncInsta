import UIKit
import AsyncDisplayKit
import Alamofire

class UserViewController: UIViewController {

    @IBOutlet var loadingView: UIView!
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    let loadingLabel = UILabel(frame: .zero)

    @IBOutlet var profilePicture: ASImageNode!
    @IBOutlet var usernameLable: UILabel!
    @IBOutlet var bioLabel: UILabel!

    let ad = UIApplication.sharedApplication().delegate as! AppDelegate

    var user: User? {
        didSet {
            finishedLoading()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLoadingView()
        ad.networking.getUserProfile{
            self.user = $0
        }
    }

    func finishedLoading(){
        configureUser()
        removeLoadingSpinner()
    }

    //MARK: - Private
    private func configureLoadingView(){
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        spinner.translatesAutoresizingMaskIntoConstraints = false

        loadingView.layer.cornerRadius = 40
        loadingView.addSubview(spinner)
        loadingLabel.text = "Loading User Profile"
        loadingView.addSubview(loadingLabel)
        spinner.centerXAnchor.constraintEqualToAnchor(loadingView.centerXAnchor).active = true
        spinner.centerYAnchor.constraintEqualToAnchor(loadingView.centerYAnchor).active = true

        loadingLabel.centerXAnchor.constraintEqualToAnchor(loadingView.centerXAnchor).active = true
        loadingLabel.topAnchor.constraintEqualToAnchor(spinner.bottomAnchor, constant: 8).active = true

        spinner.startAnimating()
    }

    private func configureUser(){
        usernameLable.text = user?.username
        bioLabel.text = user?.bio
        let backgroundQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
        dispatch_async(backgroundQueue){
        }
    }

    private func removeLoadingSpinner(){
        spinner.stopAnimating()
        loadingView.hidden = true
    }

}

struct User {
    let id: String
    let profilePicture: NSURL
    let username: String
    let bio: String
}