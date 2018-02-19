import Foundation
import UIKit
import FBSDKCoreKit
import Alamofire
import SwiftyJSON

class  FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var global_feed = Feed()
    var friends_feed = Feed()
    var your_feed = Feed()
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        // TODO: Change this to occur on pull down
        case 0:
            Feed.getFeed(feed_type: "/all", completion: {
                (feed: Feed?) in
                guard let new_feed = feed else {
                    print("error")
                    return
                }
                self.global_feed = new_feed
                self.tableView.reloadData()
            })
            
        case 1:
            Feed.getFeed(feed_type: "/friends", completion: {
                (feed: Feed?) in
                guard let new_feed = feed else {
                    print("error")
                    return
                }
                self.friends_feed = new_feed
                self.tableView.reloadData()
            })
            
        default:
            Feed.getFeed(feed_type: "", completion: {
                (feed: Feed?) in
                guard let new_feed = feed else {
                    print("error")
                    return
                }
                self.your_feed = new_feed
                self.tableView.reloadData()
            })
        }
        
        tableView.reloadData()
    }
    
    let segments = ["Everyone", "Friends", "You"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Load in friend feed
        Feed.getFeed(feed_type: "/friends", completion: {
            (feed: Feed?) in
            guard let new_feed = feed else {
                print("error")
                return
            }
            self.friends_feed = new_feed
            self.tableView.reloadData()
        })
        
        self.segmentedControl.setup(segmentNames: segments, color: UIColor.orange)
        self.segmentedControl.selectedSegmentIndex = 1
        
        // table view init
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    
    }
    
    // tableview stuff
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // feed = 0
        var count: Int = 5
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            // global feed, TODO: set page size
            count = global_feed.data.count
        case 1:
             // friends feed
            count = friends_feed.data.count
        case 2:
             // your feed
            count = your_feed.data.count
        default:
            // should never happen
            break
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 44 is the standard height of a row
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("FeedTableViewCell", owner: self, options: nil)?.first as! FeedTableViewCell
        
        switch self.segmentedControl.selectedSegmentIndex {
            
        case 0: // global feed
            cell.labelTitle.text = "\(String(describing: global_feed.data[indexPath.row].feed_text))"
            cell.labelSubtitle.text = "and had a great time!"
            return cell
            
        case 1: // friends feed
            cell.labelTitle.text = "\(String(describing: friends_feed.data[indexPath.row].feed_text))"
            return cell
            
        case 2: // your feed
            cell.labelTitle.text = "\(String(describing: your_feed.data[indexPath.row].feed_text))"
            return cell
            
        default: // should never happen
            return UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // keeps a row from being permenantly selected
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

