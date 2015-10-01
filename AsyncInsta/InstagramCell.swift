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

    }
    func buildSubnodeHierarchy(){
        addSubnode(img)
        addSubnode(caption)
    }

    override func calculateSizeThatFits(constrainedSize: CGSize) -> CGSize {

        let top80Percent = CGSize(width: constrainedSize.width, height: constrainedSize.height * 0.8)//height is out of control
        img.measure(top80Percent)

        let bottom20Percent = CGSize(width: constrainedSize.width, height: constrainedSize.height * 0.2)
        caption.measure(bottom20Percent)

        let total = CGSize(width: constrainedSize.width, height: img.calculatedSize.height + caption.calculatedSize.height)
        return total
    }
    override func layout() {
        img.frame = CGRect(origin: CGPointZero, size: img.calculatedSize).integral
        caption.frame = CGRect(origin: CGPoint(x: 0, y: img.frame.height), size: caption.calculatedSize)
    }
}


