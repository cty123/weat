//
//  EditProfileViewController.swift
//  Weat
//
//  Created by Jordan Barkley on 2/23/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class EditProfileViewController: UIViewController {
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var textFieldLocation: UITextField!
    @IBOutlet weak var switchShowArchived: UISwitch!
    
    let loginManager: FBSDKLoginManager = FBSDKLoginManager()
    @IBAction func logout(_ sender: UIButton) {
        loginManager.logOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
        self.present(vc, animated: true, completion: nil)
    }
    // action for closing button
    @IBAction func action(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(self.switchShowArchived.isOn , forKey: "showArchived")
    }
    
    @IBAction func save(_ sender: UIButton) {
        // TODO: input validation
        var name = self.textFieldName.text
        var email = self.textFieldEmail.text
        var phone = self.textFieldPhone.text
        var location = self.textFieldLocation.text
        
        if (name == nil) {
            name = ""
        }
        
        if (email == nil) {
            email = ""
        }
        
        if (phone == nil) {
            phone = ""
        }
        
        if (location == nil) {
            location = ""
        }
        
        // update user in db
        let user = User()
        user.id = UserDefaults.standard.integer(forKey: "id")
        user.name = name
        user.email = email
        user.phone = phone
        user.location = location
        user.privacy = 0
        user.updateUserInfo() { result in
            switch result{
            case .success(_):
                print("success")
            case .failure(let error):
                // Can do error handling with this error
                print(error)
                print("failure")
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let showArchived = UserDefaults.standard.object(forKey: "showArchived"){
            // if the key exists
            self.switchShowArchived.isOn = showArchived as! Bool
        } else {
            UserDefaults.standard.set(false, forKey: "showArchived")
            self.switchShowArchived.isOn = false
        }
        
        // populate fields
        let id = UserDefaults.standard.string(forKey: "id")

        User.getUserInfo(profile_id: id!){result in
            switch result {
                case .success(let user):
                    self.textFieldName.text = user.name
                    self.textFieldEmail.text = user.email
                    self.textFieldPhone.text = user.phone
                    self.textFieldLocation.text = user.location
                case .failure(let error):
                    print("File: \(#file)")
                    print("Line: \(#line)")
                    print(error)
            }
        }
        
        self.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(action))
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }

}
