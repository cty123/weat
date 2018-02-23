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
        
        if let name = UserDefaults.standard.string(forKey: "name") {
            self.textFieldName.text = name
        }
        
        if let email = UserDefaults.standard.string(forKey: "email") {
            self.textFieldEmail.text = email
        }
        
        if let phone = UserDefaults.standard.string(forKey: "phone") {
            self.textFieldPhone.text = phone
        }
        
        if let location = UserDefaults.standard.string(forKey: "location") {
            self.textFieldLocation.text = location
        }
        
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
        
        // TODO: update db!!!! can't do it atm
        UserDefaults.standard.set(name, forKey: "name")
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(phone, forKey: "phone")
        UserDefaults.standard.set(location, forKey: "location")

    }

}
