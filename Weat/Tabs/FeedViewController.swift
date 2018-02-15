import Foundation
import UIKit
import FBSDKCoreKit

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
    
    /*static func getYouFeed() {
        let url = "http://127.0.0.1:3000/user/profile"
        let user:User = User()
        Alamofire.request(url, method:.get, parameters:params).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                let user:User = User()
                user.name = json["user"]["name"].string
                user.location = json["user"]["location"].string
                user.email = json["user"]["email"].string
                user.id = json["user"]["id"].int
                user.privacy = json["user"]["email"].int
                user.phone = json["user"]["phone"].string
                print(user)
            case .failure(let error):
                print(error)
            }
        }
        return user
    }*/
    
}

