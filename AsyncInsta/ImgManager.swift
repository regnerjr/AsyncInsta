//import Foundation
import AsyncDisplayKit
import Alamofire

class ImageManager: NSObject, ASImageCacheProtocol, ASImageDownloaderProtocol {

    let cache = NSCache()

    func fetchCachedImageWithURL(URL: NSURL!, callbackQueue: dispatch_queue_t!, completion: ((CGImage!) -> Void)!) {
        guard let URL = URL,
            img = cache.objectForKey(URL.absoluteString) as? UIImage,
            cgImage = img.CGImage
            else {
                dispatch_async(callbackQueue) {
                    completion(nil)
                }
                return
        }
        cache.setObject(img, forKey: URL.absoluteString) //refresh cache
        dispatch_async(callbackQueue, { //callback
            completion(cgImage)
        })
    }

    func downloadImageWithURL(URL: NSURL!, callbackQueue: dispatch_queue_t!, downloadProgressBlock: ((CGFloat) -> Void)!, completion: ((CGImage!, NSError!) -> Void)!) -> AnyObject! {
        let queue = callbackQueue != nil ? callbackQueue! : dispatch_get_main_queue()! //if que is nill use main queue

        guard let url = URL else {
            dispatch_async(queue){
                completion(nil, NSError(domain: "DownloadFail", code: 0, userInfo: nil))
            }
            return nil
        }

        let cachesDir = Alamofire.Request.suggestedDownloadDestination(directory: .CachesDirectory, domain: .UserDomainMask)
        Alamofire.download(.GET, url.absoluteString, destination: cachesDir)
            .progress { (bytesRead, totalBytesRead, totalBytesExpected) -> Void in
                dispatch_async(queue, {
                    downloadProgressBlock?(CGFloat(totalBytesRead/totalBytesExpected))
                })
            }
            .response { (request, response, _, error) -> Void in
                if error != nil || response?.statusCode != 200 {
                    //crap some error
                    dispatch_async(queue){
                        completion(nil, error! as NSError)
                    }
                }
                dispatch_async(queue){
                    let fm = NSFileManager.defaultManager()
                    guard let
                        cachesURL = fm.URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask).first,
                        // any way to not read this entire folder ever time we download a new file, Takes a long time
                        contents = try? fm.contentsOfDirectoryAtURL(cachesURL, includingPropertiesForKeys: nil, options: [.SkipsHiddenFiles])
                    else {
                        completion(nil, NSError(domain: "CouldNotFindFileError", code: 404, userInfo: nil))
                        return
                    }
                    //FIXME: Ask for help with this one
                    // this guy could be sped up too, no filtering needed if we did not have to look at the whole folder to see the file we just downloaded
                    let matches = contents.filter{$0.lastPathComponent == url.lastPathComponent}
                    guard let
                        path = matches.first?.path,
                        img = UIImage(contentsOfFile: path)
                    else {
                        completion(nil, NSError(domain: "CouldNotFindFileError", code: 404, userInfo: nil))
                        return
                    }
                    //save in cache
                    self.cache.setObject(img, forKey: url.absoluteString)
                    completion(img.CGImage, nil)
                }

        }
        return url.absoluteString //for use in canceling the download
    }

    func cancelImageDownloadForIdentifier(downloadIdentifier: AnyObject!) {
        //Cancel it
        print("Canceling Download for \(downloadIdentifier)")
    }
}
