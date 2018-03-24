//
//  FindFriendsViewController.swift
//  Weat
//
//  Created by Sean Becker on 2/25/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import SwiftyJSON

class FindFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var facebookFriendsButton: UIButton!
    @IBOutlet weak var facebookFriendsCount: UILabel!
    @IBOutlet weak var contactsButton: UIButton!
    @IBOutlet weak var contactsCount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var facebookLinks: [String] = []                        // facebook ids from graph api
    var facebookUsers: [User] = []                          // array of Weat.User objects based on facebook id
    
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
        
        // Set up buttons (the "Facebook Friends" and "Contacts" are labels)
        facebookFriendsButton.setup(title: "", color: UIColor.white)
        // contactsButton.setup(title: "", color: UIColor.white)
        
        // Get and set facebook friends count
        facebookFriendsCount.text = "40" // Placeholder TODO: Replace
        
        
        
        
        // Get and set contacts count
        // contactsCount.text = "4" // Placeholder TODO: Replace
        
        // Add Done button
        let backButton:UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done , target: self, action: #selector(action))
        self.navigationBar.topItem?.leftBarButtonItem = backButton
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setFriends()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
        
        
        // Do any additional setup after loading the view.
    }

    
    /*
    User.getUserInfo(profile_id: id!){result in
    switch result {
    case .success(let user):
    self.labelName.text = user.name
    self.labelLocation.text = user.location
    case .failure(let error):
    print(error)

    }
    }
 */
    
    
    public func setFriends() {
        // populate facebookFriends
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "friends"]).start(completionHandler: { (connection, result, error) -> Void in
            
            if (error == nil) {
                // if successful
                
                let json = JSON(result ?? JSON.null)
                let friends = json["friends", "data"]
                print(friends)
                
                // shitty iteration of friends to get IDs
                var i = 0
                while (true) {
                    // get individual json
                    let temp = JSON(friends[i])
                    
                    // check for null
                    if (temp == JSON.null) {
                        break
                    }
                    
                    // if not null, set id array and append
                    self.facebookLinks.append(temp["id"].stringValue)
                    
                    // increment i
                    i = i + 1
                }
                
            } else {
                // if unsucessful
                print("File: \(#file)")
                print("Line: \(#line)")
                print(error)
            }
            
            self.tableView.reloadData()
        })
        
        // populate facbookUsers
        // TODO: continue after backend update from tianyu
        
    }
    
    // tableview stuff
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.facebookLinks.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // default height of tableview cell
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // setup cell
        let cell = Bundle.main.loadNibNamed("FriendTableViewCell", owner: self, options: nil)?.first as! FriendTableViewCell
        // cell.labelName.text = facebookUsers[indexPath.row].name
        cell.labelName.text = facebookLinks[indexPath.row]
        // TODO: images
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // unselect row
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
