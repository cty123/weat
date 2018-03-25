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

class FindFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var facebookFriendsCount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // vars
    var segments = ["Weat", "Facebook"]
    
    // segment 1 vars
    var weatFriends: [User] = []

    // segement 2 vars
    var facebookLinks: [String] = []                        // facebook ids from graph api
    var facebookUsers: [User] = []                          // array of Weat.User objects based on facebook id
    

    
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
        self.searchBar.delegate = self
        self.segmentedControl.setup(segmentNames: segments, color: UIColor.orange)
        self.tableView.reloadData()
        
    }
    
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
                    let link = temp["id"].stringValue
                    
                    // get user info from database
                    Friend.getUserByFacebookLink(facebook_link: link){ result in
                        switch result{
                        case .success(let user):
                            self.facebookUsers.append(user)
                            self.tableView.reloadData()
                            print("File: \(#file)")
                            print("Line: \(#line)")
                            print("got Weat.User from facebook_id")
                        case .failure(_):
                            print("File: \(#file)")
                            print("Line: \(#line)")
                            print("failed to get Weat.User from facebook_id")
                        }
                    }
                    
                    // increment i
                    i = i + 1
                }
                
            } else {
                // if unsucessful
                print("File: \(#file)")
                print("Line: \(#line)")
                print(error)
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
            return self.facebookUsers.count
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
            cell.labelName.text = self.facebookUsers[indexPath.row].name
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
            
            // open friend view controller
            let vc = FriendViewController(nibName: "FriendViewController", bundle: nil)
            vc.facebookLink = self.facebookLinks[indexPath.row]
            self.present(vc, animated: true, completion: nil)
            
        case 2: // Contacts
            break
        default:
            break
        }
    
    }
    
    // search bar stuff
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // search every time they change text(?)
            let testGroup = DispatchGroup()
            // var flag = false
            testGroup.enter()
            Friend.searchFriend(search_criteria: searchText, page: nil, limit: nil){ users in
                // XCTAssert(users[0].name == "test1")
                // flag = true
                self.weatFriends = users
                self.tableView.reloadData()
                testGroup.leave()
            }
            testGroup.notify(queue: .main){
                // XCTAssert(flag)
            }
    }
}
