import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Alamofire
import SwiftyJSON

class LoginController: UIViewController{
    
    @IBOutlet weak var loginbtn: UIButton!
    
    let loginManager: FBSDKLoginManager = FBSDKLoginManager()
    var fbLoginSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (FBSDKAccessToken.current() != nil && fbLoginSuccess == true)
        {
            performSegue(withIdentifier: "finishLogin", sender: self)
        }
    }
    
    @IBAction func loginToFacebook(_ sender: Any) {
        if FBSDKAccessToken.current() == nil {
            //Facebook Session is not active
            //Facebook Login
            //Take default permissions("public_profile","email","user_friends")
            loginManager.logIn(withReadPermissions: ["public_profile","email","user_friends"], from: self, handler:
                {(result:FBSDKLoginManagerLoginResult!, error:Error!) -> Void in
                    if error != nil {
                        //error
                    } else if result.isCancelled {
                        //Login process cancelled by user
                    } else {
                        self.fbLoginSuccess = true
                        //Successfully loggedIn
                        
                        // Complete Weat API call
                        let token = FBSDKAccessToken.current().tokenString!
                        let url = "\(String(WeatAPIUrl))/auth/facebook/token?access_token=\(String(describing: token))"
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
                                // Testing pulling friends
                                /*FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "friends"]).start(completionHandler: { (connection, result, error) -> Void in
                                    if (error == nil){
                                        print(result as Any)
                                    } else {
                                        print(error as Any)
                                    }
                                })*/
                            case .failure(let error):
                                print(error)
                            }
                        }
                        
                        self.loginbtn.titleLabel?.text = "Facebook Logout"
                        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, relationship_status"]).start(completionHandler: {(connection, result, error) -> Void in
                            if (error == nil){
                                let fbDetails = result as! NSDictionary
                                print(fbDetails)
                            }
                        })
                    }
            })
        } else {
            //Facebook session is active
            //Facebook Logout
            loginManager.logOut()   // Why are we logging out?
            self.loginbtn.titleLabel?.text = "Facebook Login" // Might not want this when we have a logout button
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
