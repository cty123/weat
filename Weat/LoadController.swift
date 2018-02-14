import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoadController: UIViewController {
    var isLoggedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if FBSDKAccessToken.current() != nil {
            isLoggedIn = true
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
