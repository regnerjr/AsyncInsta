import UIKit
import AsyncDisplayKit

class UserNode: ASDisplayNode {

    let profileImage: ASNetworkImageNode
    let userNameLabel: ASTextNode
    let userBioLabel: ASTextNode
    let imgCache = (UIApplication.sharedApplication().delegate as! AppDelegate).cache
    init(user: User){
        profileImage = ASNetworkImageNode(cache: imgCache, downloader: imgCache)
        userNameLabel = ASTextNode()
        userBioLabel = ASTextNode()
        super.init()
        setupSubNodesWithUser(user)
        buildSubNodeHierarchy()
    }

    func setupSubNodesWithUser(user: User){
        profileImage.URL = user.profilePicture
        profileImage.defaultImage = UIImage(named: "default-avatar")!
        profileImage.layer.cornerRadius = 10.0
        userNameLabel.attributedString = NSAttributedString(string: user.username)
        userBioLabel.attributedString = NSAttributedString(string: user.bio)
    }

    func buildSubNodeHierarchy(){
        addSubnode(profileImage)
        addSubnode(userNameLabel)
        addSubnode(userBioLabel)

    }

    override func calculateSizeThatFits(constrainedSize: CGSize) -> CGSize {
        //profile image gets 1/3
        let oneThird = CGSize(width: constrainedSize.width * (1.0/3.0), height: constrainedSize.height)
        profileImage.measure(oneThird)
        let twoThirdsTopThird = CGSize(width: constrainedSize.width * (2.0/3.0), height: constrainedSize.height * (1.0/3.0))
        userNameLabel.measure(twoThirdsTopThird)
        let rest = CGSize(width: constrainedSize.width * (2.0/3.0), height: constrainedSize.height * (2.0/3.0))
        userBioLabel.measure(rest)
        let width = profileImage.calculatedSize.width + max(userNameLabel.calculatedSize.width, userBioLabel.calculatedSize.width)
        let height = max(profileImage.calculatedSize.height, userNameLabel.calculatedSize.height + userBioLabel.calculatedSize.height)
        return CGSize(width: width, height: height)
    }

    override func layout() {
        profileImage.frame = CGRect(origin: CGPointZero, size: profileImage.calculatedSize).integral
        userNameLabel.frame = CGRect(x: profileImage.bounds.width, y: 0, width: userNameLabel.calculatedSize.width, height: userNameLabel.calculatedSize.height)
        userBioLabel.frame = CGRect(x: profileImage.bounds.width, y: userNameLabel.bounds.height, width: userBioLabel.calculatedSize.width, height: userBioLabel.calculatedSize.height)
    }

    //maybe need to import the Async DisplayKit through a Bridging header from a static lib,
    //so i can access the ASDisplayNode (Subclassing) Category

}