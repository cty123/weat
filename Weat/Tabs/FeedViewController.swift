import Foundation
import UIKit
import FBSDKCoreKit
import Alamofire
import SwiftyJSON

class  FeedViewController: UIViewController {
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            print("Everyone")
            // Move to everyone list view
        case 1:
            print("Friends")
            // Move to friends list view
        default:
            print("You")
            let feed = Feed.getYouFeed()
            // Move to your list view
            break;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //let access_token = FBSDKAccessToken.current().tokenString!
        //let user = User.getUserInfo(params: ["access_token":access_token])
        
    }
    
}

