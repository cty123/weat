import Foundation
import UIKit
import FBSDKCoreKit
import Alamofire
import SwiftyJSON

class  FeedViewController: UIViewController {
    var global_feed = Feed()
    var friends_feed = Feed()
    var your_feed = Feed()
    
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            Feed.getFeed(feed_type: "/all", completion: {
                (feed: Feed?) in
                guard let new_feed = feed else {
                    print("error")
                    return
                }
                self.global_feed = new_feed
                print(self.global_feed.data)
                // Move to everyone list view
            })
            
        case 1:
            Feed.getFeed(feed_type: "/friends", completion: {
                (feed: Feed?) in
                guard let new_feed = feed else {
                    print("error")
                    return
                }
                self.friends_feed = new_feed
                print(self.friends_feed.data)
                // Move to friends list view
            })
            
        default:
            Feed.getFeed(feed_type: "", completion: {
                (feed: Feed?) in
                guard let new_feed = feed else {
                    print("error")
                    return
                }
                self.your_feed = new_feed
                print(self.your_feed.data)
                // Move to everyone list view
            })
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

