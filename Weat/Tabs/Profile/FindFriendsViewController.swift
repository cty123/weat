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
    @IBOutlet weak var facebookFriendsCount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // vars
    var segments = ["Weat", "Facebook"]

    // segement 1 vars
    var facebookLinks: [String] = []                        // facebook ids from graph api
    var facebookNames: [String] = []                        // array of names from facebook graph api
    
    // segment 2 vars
    var weatFriends: [User] = []
    
    // action for closing button
    @IBAction func action(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func segmentChanged(_ sender: Any) {
        self.tableView.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Add Done button
        let backButton:UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done , target: self, action: #selector(action))
        self.navigationBar.topItem?.leftBarButtonItem = backButton
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setFriends()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.segmentedControl.setup(segmentNames: segments, color: UIColor.orange)
        self.tableView.reloadData()
        
    }
    
    public func setFriends() {
        // populate facebookFriends
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "friends"]).start(completionHandler: { (connection, result, error) -> Void in
            
            if (error == nil) {
                // if successful
                
                let json = JSON(result ?? JSON.null)
                for friend in json["friends"]["data"] {
                    self.facebookLinks.append(friend.1["id"].string!)
                    self.facebookNames.append(friend.1["name"].string!)
                }
                self.tableView.reloadData()
            } else {
                // if unsucessful
                print("File: \(#file)")
                print("Line: \(#line)")
                print(error!)
            }
        })
    }
        
    // tableview stuff
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:  // Weat
            return self.weatFriends.count
        case 1: // Facebook
            return self.facebookNames.count
        case 2: // Contacts
            break
        default:
            break
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // default height of tableview cell
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // setup cell
        let cell = Bundle.main.loadNibNamed("FriendTableViewCell", owner: self, options: nil)?.first as! FriendTableViewCell

        // TODO: images
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:  // Weat
            cell.labelName.text = self.weatFriends[indexPath.row].name
        case 1: // Facebook
            cell.labelName.text = self.facebookNames[indexPath.row]
        case 2: // Contacts
            break
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // unselect row
        tableView.deselectRow(at: indexPath, animated: true)
        
        // action on cell press
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:  // Weat
            break
        case 1: // Facebook
            let vc = FriendViewController(nibName: "FriendViewController", bundle: nil)
            Friend.getUserByFacebookLink(facebook_link: facebookLinks[indexPath.row]){ result in
                switch result{
                case .success(let user):
                    vc.user = user
                    // open friend view controller
                    self.present(vc, animated: true, completion: nil)
                    print("File: \(#file)")
                    print("Line: \(#line)")
                    print("got Weat.User from facebook_id")
                case .failure(_):
                    print("File: \(#file)")
                    print("Line: \(#line)")
                    print("failed to get Weat.User from facebook_id")
                }
            }
        case 2: // Contacts
            break
        default:
            break
        }
        

    }
}
