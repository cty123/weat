import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

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
            loginManager.logOut()
            self.loginbtn.titleLabel?.text = "Facebook Login"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
