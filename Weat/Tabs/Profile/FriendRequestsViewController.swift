//
//  FriendRequestsViewController.swift
//  Weat
//
//  Created by Jordan Barkley on 2/23/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import UIKit

// for pending friend requests
class FriendRequestsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    // action for closing button
    @IBAction func action(_ sender: UIBarButtonItem) {
        // respond to all friend requests based on the status
        /*var i: Int = 0
        for friend in pendingRequests {
            
            let cell = self.tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! FriendRequestTableViewCell
            print(cell.acceptance)
            Friend.setFriendRequest(friend_id: String(describing: friend.id), acceptance: cell.acceptance, completion: {
                (ret: Bool) in
                print("setFriendRequest returned \(ret)")
            })
        
            i = i + 1
        }*/
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // vars
    var pendingRequests: [User] = []
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()

        // add close button
        self.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(action))
        
        // get requests
        /*Friend.pullFriendRequest(completion: {
            (users: [User]?) in
            
            // TODO: fix this
            if (users != nil) {
                self.pendingRequests = users!
            } else {
                print("error getting friend requests")
            }
        })*/
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
        
    }
    
    // tableview stuff
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return self.pendingRequests.count
        return profileVars.friendRequests.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // height of FriendRequestTableViewCell
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("FriendRequestTableViewCell", owner: self, options: nil)?.first as! FriendRequestTableViewCell
        
        // set up buttons
        cell.buttonDeny.setup(title: "Deny", color: UIColor.orange)
        cell.buttonConfirm.setup(title: "Confirm", color: UIColor.orange)
        let friend = profileVars.friendRequests[indexPath.row]
        cell.friend = friend
        // set up name
        // cell.labelName.text = self.pendingRequests[indexPath.row].name
        cell.labelName.text = "\((friend.name)!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // unselect row
        tableView.deselectRow(at: indexPath, animated: true)
    }


}
