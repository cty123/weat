import Foundation
import UIKit

class  FriendFeedController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let user = User.getUserInfo(params: ["profile_id":"1","access_token":"test"])
    }
}

