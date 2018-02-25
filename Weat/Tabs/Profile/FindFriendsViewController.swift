//
//  FindFriendsViewController.swift
//  Weat
//
//  Created by Sean Becker on 2/25/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import UIKit

class FindFriendsViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var facebookFriendsButton: UIButton!
    @IBOutlet weak var facebookFriendsCount: UILabel!
    @IBOutlet weak var contactsButton: UIButton!
    @IBOutlet weak var contactsCount: UILabel!
    
    // action for closing button
    @IBAction func action(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func facebookFriendsButton(_ sender: UIButton) {
        let facebookFriendsViewController = FacebookFriendsViewController(nibName: "FacebookFriendsViewController", bundle: nil)
        self.present(facebookFriendsViewController, animated: true, completion: nil)
    }
    
    @IBAction func contactsButton(_ sender: UIButton) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Set up buttons
        facebookFriendsButton.setup(title: "", color: UIColor.white)
        contactsButton.setup(title: "", color: UIColor.white)
        
        // Get and set facebook friends count
        facebookFriendsCount.text = "40" // Placeholder TODO: Replace
        
        // Get and set contacts count
        contactsCount.text = "4" // Placeholder TODO: Replace
        
        // Add Done button
        let backButton:UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done , target: self, action: #selector(action))
        self.navigationBar.topItem?.leftBarButtonItem = backButton
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
