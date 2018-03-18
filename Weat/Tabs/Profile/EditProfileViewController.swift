//
//  EditProfileViewController.swift
//  Weat
//
//  Created by Jordan Barkley on 2/23/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var textFieldLocation: UITextField!
    
    // action for closing button
    @IBAction func action(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // populate fields
        let user = User()
        let id = UserDefaults.standard.string(forKey: "id")

        User.getUserInfo(profile_id: id!){user in
            self.textFieldName.text = user.name
            self.textFieldEmail.text = user.email
            self.textFieldPhone.text = user.phone
            self.textFieldLocation.text = user.location
        }
        
        /*
        self.textFieldName.text = user.name
        self.textFieldEmail.text = user.email
        self.textFieldPhone.text = user.phone
        self.textFieldLocation.text = user.location
        */
 
        self.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(action))


    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
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
        user.updateUserInfo() { status in
            if status {
                

                print ("success")
            } else {
                

                print ("faiure")
            }
        }

    }

}
