import UIKit
import Alamofire
import SwiftyJSON

//let popularURL = "https://api.instagram.com/v1/media/popular?access_token="
let popularURL = "https://api.instagram.com/v1/media/popular"
let usersURL = "https://api.instagram.com/v1/users/"

enum Endpoint {
    case Popular
}

class Networking: NSObject {

    func getPopularImages(configuration: (([InstagramItem]) -> Void)) {

        guard let token = NSUserDefaults.standardUserDefaults().stringForKey(Defaults.AuthToken.rawValue) else {
            print("No Token!\n Bailing Early")
            return
        }

        Alamofire.request(.GET, popularURL, parameters: ["access_token": token]).response  { [weak self]
            (req: NSURLRequest?, resp: NSHTTPURLResponse?, data: NSData?, err: ErrorType?) -> Void in
            if err != nil {
                print("OMG what happened!")
                print("\(resp?.statusCode)")
                print("\((err! as NSError).localizedDescription)")
            }
            if let d = data {
                let json = JSON(data: d)
                if let items = self?.makeInstagramItemsFromJson(.Popular, json: json){
                    configuration(items)
                }
            }
        }
    }

    func getUserProfile(configuration: ((User) -> Void)){

        guard let token = NSUserDefaults.standardUserDefaults().stringForKey(Defaults.AuthToken.rawValue) else { print("No Token!\n Bailing Early")
            return
        }

        Alamofire.request(.GET, usersURL + "self/", parameters: ["access_token": token]).response  { [weak self]
            (req: NSURLRequest?, resp: NSHTTPURLResponse?, data: NSData?, err: ErrorType?) -> Void in
            if err != nil {
                print("OMG what happened!")
                print("\(resp?.statusCode)")
                print("\((err! as NSError).localizedDescription)")
            }
            if let d = data {
                let json = JSON(data: d)
                self?.makeInstagramUserFromJSON(json).map{
                    configuration($0)
                }
            }
        }
    }

    func makeInstagramUserFromJSON(json: JSON) -> User? {
        let profile = json["data"]
        let id = profile["id"].string!
        let profileURL = NSURL(string: profile["profile_picture"].string!)!
        let username = profile["username"].string!
        let bio = profile["bio"].string!
        let user = User(id: id, profilePicture: profileURL, username: username, bio: bio)
        return user
    }


    func makeInstagramItemsFromJson(endpoint: Endpoint, json: JSON) -> [InstagramItem]{
        switch endpoint {
        case .Popular:
            //should figure out how to parse this json on a background thread
            return parsePopular(json)
        }
    }

    func parsePopular(json: JSON) -> [InstagramItem]{
        var popularItems: [InstagramItem] = []
        let data = json["data"]
        for num in 0..<data.count {
            let new = data[num]
            let user = new["user"]
            let id = new["id"].string!
            let userFull = user["full_name"].string ?? ""
            let username = user["username"].string ?? ""
            let profilePic = NSURL(string: user["profile_picture"].string!)! //if no user img this is the default pic
            let img = NSURL(string: new["images"]["standard_resolution"]["url"].string!)! //image url better not be nil!
            let caption = new["caption"]["text"].string ?? "" //caption can be null
            let item = InstagramItem(
                id: id,
                userFullName: userFull,
                userName: username,
                userProfilePic: profilePic,
                imageURL: img,
                caption: caption)
            popularItems.append(item)
        }
        return popularItems
    }

    func instagramGETWithURL(url: String) {

    }
}

