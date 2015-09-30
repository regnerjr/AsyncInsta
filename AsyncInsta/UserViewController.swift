import UIKit
import AsyncDisplayKit
import Alamofire

class UserViewController: UIViewController {

    @IBOutlet weak var viewPopularPicturesButton: UIButton!
    @IBOutlet var loadingView: UIView!
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    let loadingLabel = UILabel(frame: .zero)

    var profilePicture = ASNetworkImageNode()
    var usernameLabel = ASTextNode()
    var bioLabel = ASTextNode()

    let ad = UIApplication.sharedApplication().delegate as! AppDelegate

    var user: User?
    var userNode: UserNode!
    var userNodeSetupStarted = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLoadingView()
        ad.networking.getUserProfile {
            self.user = $0
            self.finishedLoading()
            self.view.setNeedsLayout() //recalculate layout to show user profile
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if !userNodeSetupStarted && user != nil { //ensure we have a user, then layout stuff
            let width = view.bounds.width * (8.0/9.0)
            let height = view.bounds.height * (1.0/2.0)
            addUserNodeAsynchronously(CGRect(x: 0, y: 0, width: width, height: height).integral) //fit user profile in top half of screen
            userNodeSetupStarted = true
        }
    }

    func addUserNodeAsynchronously(containerRect: CGRect){
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            let userNode = self.createUserNode(containerRect)
            dispatch_async(dispatch_get_main_queue()) {
                self.view.addSubview(userNode.view)
            }
        }
    }
    
    func createUserNode(containerRect: CGRect) -> UserNode{
        userNode = UserNode(user: user!)
        userNode.measure(containerRect.size)
        let size = userNode.calculatedSize
        let origin = CGPointZero
        userNode.frame = CGRect(origin: origin, size: size)
        return userNode
    }


    func finishedLoading(){
        configureUser()
        removeLoadingSpinner()
    }

    //MARK: - Private
    private func configureLoadingView(){
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        spinner.translatesAutoresizingMaskIntoConstraints = false

        loadingView.layer.cornerRadius = 15
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
        guard let user = user else {
            //Hmm could not get user?
            //lets just bail for now
            return
        }

        usernameLabel.attributedString = NSAttributedString(string: user.username)
        view.addSubnode(usernameLabel)

        bioLabel.attributedString = NSAttributedString(string: user.bio)
        view.addSubnode(bioLabel)

        //start image Spinner
//        let img = ASNetworkImageNode()
        profilePicture.backgroundColor = ASDisplayNodeDefaultPlaceholderColor();
        profilePicture.URL = user.profilePicture
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