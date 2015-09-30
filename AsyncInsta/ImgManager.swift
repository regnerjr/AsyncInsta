import Foundation
import AsyncDisplayKit
import Alamofire

class ImageManager: NSObject, ASImageCacheProtocol, ASImageDownloaderProtocol {

    let cache = NSCache()

    func fetchCachedImageWithURL(URL: NSURL!, callbackQueue: dispatch_queue_t!, completion: ((CGImage!) -> Void)!) {
        guard let URL = URL,
            imgData = cache.objectForKey(URL.absoluteString) as? NSData,
            img = UIImage(data: imgData),
            cgImage = img.CGImage
            else {
                dispatch_async(callbackQueue) {
                    completion(nil)
                }
                return
        }
        cache.setObject(imgData, forKey: URL.absoluteString) //refresh cache
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

        let fm = NSFileManager.defaultManager()

//        Alamofire.download(.GET, URL.absoluteString, destination: destination)
//            .progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
//                dispatch_async(queue) {
//                    downloadProgressBlock(Float(totalBytesRead/totalBytesExpectedToRead))
//                }
//            }
//            .response { request, response, _, error in
//                print(response)
//                dispatch_async(queue) {
//                    completion(imgOrNil, errorOrNil)
//                }
//
//        }
        return nil
    }

    func cancelImageDownloadForIdentifier(downloadIdentifier: AnyObject!) {
        //Cancel it
        print("Canceling Download for \(downloadIdentifier)")
    }
}


//- (id)downloadImageWithURL:(NSURL *)URL
//    callbackQueue:(dispatch_queue_t)callbackQueue
//    downloadProgressBlock:(void (^)(CGFloat))downloadProgressBlock
//    completion:(void (^)(CGImageRef, NSError *))completion {
//
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL
//        cachePolicy:NSURLRequestReturnCacheDataElseLoad
//        timeoutInterval:15.0];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        if (connectionError == nil && [data isKindOfClass:[NSData class]]) {
//        CGDataProviderRef imgDataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)(data));
//        CGImageRef imageRef = CGImageCreateWithJPEGDataProvider(imgDataProvider, NULL, true, kCGRenderingIntentDefault);
//        if (imageRef == NULL) {
//        imageRef = CGImageCreateWithPNGDataProvider(imgDataProvider, NULL, true, kCGRenderingIntentDefault);
//        }
//        CFRelease(imgDataProvider);
//        if (imageRef != nil) {
//        if ([data length] < 1024 * 64) {
//        [self.avatarCacheObject setValue:data forKey:URL.absoluteString];
//        }
//        dispatch_async(callbackQueue, ^{
//        completion(imageRef, nil);
//        CFRelease(imageRef);
//        });
//        }
//        else {
//        dispatch_async(callbackQueue, ^{
//        completion(nil, [NSError errorWithDomain:@"CGImage" code:-1 userInfo:nil]);
//        });
//
//        }
//        }
//        else {
//        dispatch_async(callbackQueue, ^{
//        completion(nil, connectionError);
//        });
//        }
//        }];
//    return nil;
//}

//Alamofire.download(.GET, "http://httpbin.org/stream/100", destination: destination)
//    .progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
//        print(totalBytesRead)

// This closure is NOT called on the main queue for performance
// reasons. To update your ui, dispatch to the main queue.

