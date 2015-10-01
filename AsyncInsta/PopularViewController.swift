import UIKit
import AsyncDisplayKit

class PopularViewController: UIViewController {

    var data = Set<InstagramItem>()
    let ad = UIApplication.sharedApplication().delegate as! AppDelegate

    lazy var table: ASTableView = {
        let tv = ASTableView(frame: .zero, style: .Plain, asyncDataFetching: true)
        tv.frame = self.view.frame
        tv.asyncDelegate = self
        tv.asyncDataSource = self
        return tv
    }()

    override func viewDidLoad() {
        ad.networking.getPopularImages{
            self.data = self.data.union($0)
            self.view.setNeedsLayout()
            self.table.reloadData()
        }
        super.viewDidLoad()
        view.addSubview(table)
    }
}

extension PopularViewController: ASTableViewDataSource {
    func tableView(tableView: ASTableView!, nodeForRowAtIndexPath indexPath: NSIndexPath!) -> ASCellNode! {
        let idx = data.startIndex.advancedBy(indexPath.row)
        return InstagramCell(item: data[idx])
    }

    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        print("Data Count: \(data.count)")
        return data.count
    }

}

extension PopularViewController: ASTableViewDelegate {
    func tableView(tableView: ASTableView!, willBeginBatchFetchWithContext context: ASBatchContext!) {
        print("Begining Fetch with context \(context)")
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)){
        self.ad.networking.getPopularImages{
            let initialCount = self.data.count
            let newItems = Set<InstagramItem>($0)
            print("Data already contains \(newItems.filter{ self.data.contains($0)}.map{ $0.id })")
            let onlyNew = newItems.subtract(self.data)
            print("\(onlyNew.map{$0.id})")
            print("OnlyNew: \(onlyNew.map({$0.id}))")
            self.data.unionInPlace(onlyNew)
            let afterCount = self.data.count
            print("Added \(afterCount - initialCount) Items")
            let indexPaths = (initialCount..<afterCount).map{ NSIndexPath(forRow: $0, inSection: 0)}
            indexPaths.forEach{ print($0)}
            dispatch_async(dispatch_get_main_queue()){
                self.table.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)

                context.completeBatchFetching(true)
            }
            }
        }
    }

    func shouldBatchFetchForTableView(tableView: ASTableView!) -> Bool {
        return true
    }
}


struct InstagramItem: Hashable, Equatable {
    let id: String
    let userFullName: String
    let userName: String
    let userProfilePic: NSURL
    let imageURL: NSURL
    let caption: String
    let hashValue: Int

    init(id:String, userFullName: String, userName: String, userProfilePic: NSURL, imageURL: NSURL, caption: String){
        self.id = id
        self.userFullName = userFullName
        self.userName = userName
        self.userProfilePic = userProfilePic
        self.imageURL = imageURL
        self.caption = caption
        hashValue = id.hashValue
    }

}
func ==(lhs: InstagramItem, rhs: InstagramItem) -> Bool{
    return lhs.hashValue == rhs.hashValue
}