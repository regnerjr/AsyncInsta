import UIKit
import AsyncDisplayKit

class PopularViewController: UIViewController {

    var data = [InstagramItems]()
    let ad = UIApplication.sharedApplication().delegate as! AppDelegate

    lazy var table: ASTableView = {
        let tv = ASTableView(frame: .zero, style: .Plain, asyncDataFetching: true)
        tv.asyncDelegate = self
        tv.asyncDataSource = self
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        ad.networking.getPopularImages{
            self.data = $0
        }
        //add table as subview
        //configure constraints for table
        //set table delegate and datasource

    }
}

extension PopularViewController: ASTableViewDataSource {
    func tableView(tableView: ASTableView!, nodeForRowAtIndexPath indexPath: NSIndexPath!) -> ASCellNode! {
        return ASCellNode()
    }
//    func tableViewLockDataSource(tableView: ASTableView!) {
//
//    }
//    func tableViewUnlockDataSource(tableView: ASTableView!) {
//        <#code#>
//    }
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }


}

extension PopularViewController: ASTableViewDelegate {
    func tableView(tableView: ASTableView!, willBeginBatchFetchWithContext context: ASBatchContext!) {
        print("Begining Fetch with context \(context)")
    }
    func shouldBatchFetchForTableView(tableView: ASTableView!) -> Bool {
        return true
    }
}


struct InstagramItems {
    let imageURL: NSURL
    let userName: String
    let comment: String
}