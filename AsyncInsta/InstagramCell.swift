import UIKit
import AsyncDisplayKit
import Alamofire

class InstagramCell: ASCellNode {

    let cache = (UIApplication.sharedApplication().delegate as! AppDelegate).cache

    let img: ASNetworkImageNode
    let caption: ASTextNode
    let userFullName: ASTextNode
    let username: ASTextNode
    let profilePic: ASNetworkImageNode

    init(withInstagramItem: InstagramItem){
        img = ASNetworkImageNode(cache: cache, downloader: cache)
        caption = ASTextNode()
        profilePic = ASNetworkImageNode(cache: cache, downloader: cache)
        userFullName = ASTextNode()
        username = ASTextNode()
       super.init()
    }
}


