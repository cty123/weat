//
//  GroupCreateViewController.swift
//  Weat
//
//  Created by Jordan Barkley on 4/8/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import UIKit

class GroupCreateViewController: UIViewController {
    
    // outlets
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    // actions
    @IBAction func pressDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressCreate(_ sender: Any) {
        var name: String
        if let _ = self.textField.text {
            name = self.textField.text!
        } else {
            name = ""
        }
        let icon = 0
        
        Group.create(group_name: name, icon_id: icon){ result in
            if !result {
                print("File: \(#file)")
                print("Line: \(#line)")
                print("failed to create group")
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // add done button
        self.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(pressDone))
        
        // add recommend button
        self.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pressCreate))
    }
    
}
