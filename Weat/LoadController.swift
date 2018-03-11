import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire
import SwiftyJSON

class LoadController: UIViewController {
    var isLoggedIn = false
    var latitude: Double?   // Used to store location for explore view
    var longitude: Double?  // Used to store location for explore view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Authenticate using Weat API
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(FBSDKAccessToken.current() != nil) {
            let token = FBSDKAccessToken.current().tokenString!
            let url = "\(WeatAPIUrl)/auth/facebook/token?access_token=\(String(describing: token))"
            print("Getting url \(String(describing: url))")
            Alamofire.request(url, method: .get).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    UserDefaults.standard.set(json["id"].int, forKey: "id")
                    UserDefaults.standard.set(json["name"].string, forKey: "name")
                    UserDefaults.standard.set(json["email"].string, forKey: "email")
                    UserDefaults.standard.set(json["location"].string, forKey: "location")
                    UserDefaults.standard.set(json["privacy"].int, forKey: "privacy")
                    UserDefaults.standard.set(json["phone"].string, forKey: "phone")
                    self.isLoggedIn = true
                    self.performSegue(withIdentifier: "enterApp", sender: self)
                    // Testing pulling friends
                    /*FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "friends"]).start(completionHandler: { (connection, result, error) -> Void in
                     if (error == nil){
                     print(result as Any)
                     } else {
                     print(error as Any)
                     }
                     })*/
                case .failure(let error):
                    self.isLoggedIn = false
                    self.performSegue(withIdentifier: "enterLogin", sender: self)
                }
            }
        } else {
            self.performSegue(withIdentifier: "enterLogin", sender: self)
            isLoggedIn = false
        }
        if (isLoggedIn)
        {
     //       performSegue(withIdentifier: "enterApp", sender: self)
        }else{
    //        performSegue(withIdentifier: "enterLogin", sender: self)
        }
    }
}
