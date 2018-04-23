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
    
    // outlets
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var textFieldLocation: UITextField!
    @IBOutlet weak var segmentedControlArchive: UISegmentedControl!
    @IBOutlet weak var segmentedControlPrivacy: UISegmentedControl!
    @IBOutlet weak var buttonLogout: UIButton!
    
    
    
    // vars
    var segmentsPrivacy = ["Everyone", "Only Me", "Friends"]
    var segmentsArchive = ["Hide", "Show"]
    
    let loginManager: FBSDKLoginManager = FBSDKLoginManager()
    @IBAction func logout(_ sender: UIButton) {
        loginManager.logOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    // action for closing button
    @IBAction func pressCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save() {
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
        user.privacy = self.segmentedControlPrivacy.selectedSegmentIndex
        user.updateUserInfo() { result in
            switch result{
            case .success(_):
                print("success")
            case .failure(let error):
                // Can do error handling with this error
                print(error)
                print("failure")
            }
            
            // save showArchived
            if self.segmentedControlArchive.selectedSegmentIndex == 1 {
                UserDefaults.standard.set(true , forKey: "showArchived")
            } else {
                UserDefaults.standard.set(false , forKey: "showArchived")
            }
            
            
            // exit
            self.dismiss(animated: true, completion: nil)
            
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let showArchived = UserDefaults.standard.object(forKey: "showArchived") as? Bool{
            // if the key exists
            if showArchived {
                // show
                self.segmentedControlArchive.selectedSegmentIndex = 1
            } else {
                // hide
                self.segmentedControlArchive.selectedSegmentIndex = 0
            }
        
        } else {
            // hide
            UserDefaults.standard.set(false, forKey: "showArchived")
            self.segmentedControlArchive.selectedSegmentIndex = 0

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
        
        // add buttons
        self.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(pressCancel))
        self.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        self.buttonLogout.setup(title: "Logout", color: .orange)
        
        // "hide keyboard when tapped around"
        self.hideKeyboardWhenTappedAround()
        
        // init segmented controls
        self.segmentedControlPrivacy.setup(segmentNames: self.segmentsPrivacy, color: .orange)
        self.segmentedControlArchive.setup(segmentNames: self.segmentsArchive, color: .orange)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }

}
