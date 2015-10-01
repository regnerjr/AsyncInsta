//import Foundation
import AsyncDisplayKit
import Alamofire

class ImageManager: NSObject, ASImageCacheProtocol, ASImageDownloaderProtocol {

    let cache = NSURLCache.sharedURLCache()

    func fetchCachedImageWithURL(URL: NSURL!, callbackQueue: dispatch_queue_t!, completion: ((CGImage!) -> Void)!) {
        guard let URL = URL,
            response = cache.cachedResponseForRequest(NSURLRequest(URL: URL)),
            img = UIImage(data: response.data),
            cgImage = img.CGImage
            else {
                dispatch_async(callbackQueue) {
                    completion(nil)
                }
                return
        }
        //Do I need to do this?
        cache.storeCachedResponse(response, forRequest: NSURLRequest(URL: URL)) //refresh cache
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

        Alamofire.request(.GET, url)
        .response { (request, response, data, error) -> Void in
            if error != nil || response?.statusCode != 200 {
                //crap some error
                dispatch_async(queue){
                    completion(nil, error! as NSError)
                }
            }
            guard let
                request = request,
                response = response,
                data = data
            else {
                print("Don't cache this one Something is wrong. ")
                return
            }
            self.cache.storeCachedResponse(NSCachedURLResponse(response: response, data: data), forRequest: request)
            let img = UIImage(data: data)!
            completion(img.CGImage, nil)

        }
        return url.absoluteString
    }

    func cancelImageDownloadForIdentifier(downloadIdentifier: AnyObject!) {
        //Cancel it
        print("Canceling Download for \(downloadIdentifier)")
    }
}
