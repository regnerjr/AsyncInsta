import UIKit
import AsyncDisplayKit

class InstagramCell: ASCellNode {

    let cache = (UIApplication.sharedApplication().delegate as! AppDelegate).cache

    let img: ASNetworkImageNode
    let caption: ASTextNode
    let userFullName: ASTextNode
    let username: ASTextNode
    let profilePic: ASNetworkImageNode
    let item: InstagramItem

    init(item: InstagramItem){
        img = ASNetworkImageNode(cache: cache, downloader: cache)
        caption = ASTextNode()
        profilePic = ASNetworkImageNode(cache: cache, downloader: cache)
        userFullName = ASTextNode()
        username = ASTextNode()
        self.item = item
        super.init()
        setUpSubnodesWithItem(item)
        buildSubnodeHierarchy()
    }
    func setUpSubnodesWithItem(item: InstagramItem){
        img.URL = item.imageURL
        img.defaultImage = UIImage(named: "default-avatar")

        caption.attributedString = NSAttributedString(string: item.caption)
        caption.placeholderColor = UIColor(white: 0.5, alpha: 0.8)
        //and other stuff

        profilePic.URL = item.userProfilePic
        profilePic.defaultImage = UIImage(named: "default-avatar")

    }
    func buildSubnodeHierarchy(){
        addSubnode(img)
        addSubnode(caption)
        addSubnode(profilePic)
    }

    override func calculateSizeThatFits(constrainedSize: CGSize) -> CGSize {

        let top65Percent = CGSize(width: constrainedSize.width, height: constrainedSize.height * 0.65)//height is out of control
        img.measure(top65Percent)

        let slice10Percent = CGSize(width: constrainedSize.width, height: constrainedSize.height * 0.10)
        caption.measure(slice10Percent)

        let rightHandBottomQuarter = CGSize(width: constrainedSize.width * 0.25, height: constrainedSize.height * 0.25)
        profilePic.measure(rightHandBottomQuarter)

        let total = CGSize(width: constrainedSize.width, height: img.calculatedSize.height + caption.calculatedSize.height + profilePic.calculatedSize.height)
        return total
    }
    override func layout() {
        img.frame = CGRect(origin: CGPointZero, size: img.calculatedSize).integral
        caption.frame = CGRect(origin: CGPoint(x: 0, y: img.frame.height), size: caption.calculatedSize)

        let profileOrigin = CGPoint(x: bounds.width - profilePic.calculatedSize.width, y:img.calculatedSize.height + caption.calculatedSize.height)
        profilePic.frame = CGRect(origin: profileOrigin, size: profilePic.calculatedSize)
    }
}


