import Foundation
import UIKit
import FBSDKCoreKit
import Alamofire
import SwiftyJSON

class  FeedViewController: UIViewController {
    var global_feed:Feed
    
    //var friends_feed = Feed.getFeed(feed_type: "/friends")
    //var your_feed = Feed.getFeed(feed_type: "")
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            print("Everyone")
            print(global_feed.data as Any)
            // Move to everyone list view
            
        case 1:
            print("Friends")
            print(friends_feed.data as Any)
            // Move to friends list view
        default:
            print("You")
            print(your_feed.data as Any)
            // Move to your list view
            break;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Show "you" feed
        
        //let access_token = FBSDKAccessToken.current().tokenString!
        //let user = User.getUserInfo(params: ["access_token":access_token])
        
    }
    
}

