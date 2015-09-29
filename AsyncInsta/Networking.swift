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

    func getPopularImages(configuration: (([InstagramItems]) -> Void)) {

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

    func downloadImageAtURL(url: String, toDocumentsDirectoryWithCallback callback: (UIImage -> Void)){


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


    func makeInstagramItemsFromJson(endpoint: Endpoint, json: JSON) -> [InstagramItems]{
        switch endpoint {
        case .Popular:
            return parsePopular(json)
        }
    }

    func parsePopular(json: JSON) -> [InstagramItems]{
        if let poster = json["data"][0]["user"]["full_name"].string{
            print("Posted By: \(poster)")
        }
        return []
    }

    func instagramGETWithURL(url: String) {

    }
}

