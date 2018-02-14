import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire
import SwiftyJSON

class LoadController: UIViewController {
    var isLoggedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Authenticate using API
        /*
        let token = FBSDKAccessToken.current().tokenString!
        let url = "http://localhost:8000/auth/facebook/token?access_token=\(String(describing: token))"
        print("Getting url \(String(describing: url))")
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json["message"])  // Prints "you're logged in" if successful
                // Testing pulling friends
                FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "friends"]).start(completionHandler: { (connection, result, error) -> Void in
                    if (error == nil){
                        print(result as Any)
                    } else {
                        print(error)
                    }
                })
            case .failure(let error):
                print(error)
            }
        }
         */
        
        if FBSDKAccessToken.current() != nil {
            isLoggedIn = true
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "friends"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    print(result as Any)
                } else {
                    print(error)
                }
            })
        }else{
            isLoggedIn = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (isLoggedIn)
        {
            performSegue(withIdentifier: "enterApp", sender: self)
        }else{
            performSegue(withIdentifier: "enterLogin", sender: self)
        }
    }
}
