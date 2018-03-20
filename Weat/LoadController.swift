import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire
import SwiftyJSON

class LoadController: UIViewController {
    var latitude: Double?   // Used to store location for explore view
    var longitude: Double?  // Used to store location for explore view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Authenticate using Weat API
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(FBSDKAccessToken.current() != nil) {
            LoginController.weatLogin(completion: { (status) in
                if(status) {
                    self.performSegue(withIdentifier: "enterApp", sender: self)
                } else {
                    print("LoginController error: Can't access server. Check that it's up.")
                    self.performSegue(withIdentifier: "enterLogin", sender: self)
                }
            })
        } else {
            self.performSegue(withIdentifier: "enterLogin", sender: self)
        }
    }
}
