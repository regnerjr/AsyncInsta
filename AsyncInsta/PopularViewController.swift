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
    func scrollViewDidScroll(scrollView: UIScrollView) {
//        ad.networking.getPopularImages{
//            let initialCount = self.data.count
//            let newItems = Set<InstagramItem>($0)
//            let onlyNew = newItems.subtract(self.data)
//            print("OnlyNew: \(onlyNew)")
//            self.data.unionInPlace(onlyNew)
//            let afterCount = self.data.count
//            print("Added \(afterCount - initialCount) Items")
//            let indexPaths = (initialCount..<afterCount).map{ NSIndexPath(forRow: $0, inSection: 0)}
//            print(indexPaths)
//            self.view.setNeedsLayout()
//            self.table.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade) //reload new cells
//        }
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

    var hashValue: Int {
        let comps = id.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "_"))
        guard let
            first = Int(comps[0]),
            second = Int(comps[1])
        else {
            return 0 // zero for errors
        }
        return first + second
    }
}
func ==(lhs: InstagramItem, rhs: InstagramItem) -> Bool{
    return lhs.hashValue == rhs.hashValue
}