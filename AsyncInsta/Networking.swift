import UIKit
import Alamofire
import SwiftyJSON

//let popularURL = "https://api.instagram.com/v1/media/popular?access_token="
let popularURL = "https://api.instagram.com/v1/media/popular"
let usersURL = "https://api.instagram.com/v1/users/"

class Networking: NSObject {

    var delegate: NetworkingDelegate? = nil

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
                print("JSON: \(json)")
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
            print("Got req \(req!), with response \(resp!), and data \(data!)")
            if let d = data {
                let json = JSON(data: d)
                let data = json["data"]
                print("JSON:Data \(data)")
                self?.makeInstagramUserFromJSON(json).map{
                    configuration($0)
                }
            }
        }
    }

    func downloadImageAtURL(url: String, toDocumentsDirectoryWithCallback callback: (UIImage -> Void)){
        let destination = Alamofire.Request.suggestedDownloadDestination()
        Alamofire.download(.GET, url, destination: destination)

        let fm = NSFileManager.defaultManager()
        if let documentsDirURL = try? fm.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false),
            contents = try? fm.contentsOfDirectoryAtURL(documentsDirURL, includingPropertiesForKeys: nil, options: []) {
                print("Whats in the Documents Folder")
                for (i,item) in contents.enumerate() {
                    print("\(i) : \(item))")
                }
        }
//        let img = UIImage(contentsOfFile: destination)
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
            print("Posted By \(poster)")
        }
        return []
    }

    func instagramGETWithURL(url: String) {

    }
}

enum Endpoint {
    case Popular
}

protocol NetworkingDelegate {
    func finishedLoading()
}