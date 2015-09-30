import UIKit
import AsyncDisplayKit

class PopularViewController: UIViewController {

    var data = [InstagramItem]()
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
            self.data = $0
            self.view.setNeedsLayout()
        }
        super.viewDidLoad()
        view.addSubview(table)
    }
}

extension PopularViewController: ASTableViewDataSource {
    func tableView(tableView: ASTableView!, nodeForRowAtIndexPath indexPath: NSIndexPath!) -> ASCellNode! {
        return InstagramCell(item: data[indexPath.row])
    }

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


struct InstagramItem {
    let id: String
    let userFullName: String
    let userName: String
    let userProfilePic: NSURL
    let imageURL: NSURL
    let caption: String
}