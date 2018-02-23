//
//  FacebookFriendsViewController.swift
//  Weat
//
//  Created by Jordan Barkley on 2/23/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import UIKit

class FacebookFriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // outlets
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    // action for closing button
    @IBAction func action(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // vars
    var facebookFriends: [User] = []
    
    override func viewDidLoad() {
        // add close button
        self.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(action))
        
        // get requests
        Friend.pullFriendRequest(completion: {
            (users: [User]?) in
            
            // TODO: fix this
            if (users != nil) {
                self.facebookFriends = users!
            } else {
                print("error getting friend requests")
            }
        })
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
    }
    
    // tableview stuff
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.facebookFriends.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // height of FriendRequestTableViewCell
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("FriendTableViewCell", owner: self, options: nil)?.first as! FriendTableViewCell
        
        // set up name
        cell.labelName.text = self.facebookFriends[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // open next view controller
        let friendViewController = FriendViewController(nibName: "FriendViewController", bundle: nil)
        friendViewController.facebookLink = "1493264010796475"
        self.present(friendViewController, animated: true, completion: nil)
        
        // unselect row
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
