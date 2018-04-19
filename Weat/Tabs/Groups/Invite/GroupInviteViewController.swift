//
//  GroupInviteViewController.swift
//  Weat
//
//  Created by Jordan Barkley on 4/15/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import UIKit

class GroupInviteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    // actions
    @IBAction func pressBack(_ sender: Any) {
        // press back
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressDone(_ sender: Any) {
        // press done
        var i = 0
        var friend_ids: String = ""
        for friend in friends {
            if (self.cellSelected[i]) {
                friend_ids += "\(friend.id!),"
            }
            
            // increment i
            i = i + 1
        }
        
        // remove commas
        // friend_ids = friend_ids.dropLast()
        
        Group.invite(group_id: self.group.id!, friend_ids: friend_ids){ result in            
            if result {
                let pvc = self.presentingViewController as! GroupDetailsViewController
                pvc.getGroupMembers()
            } else {
                print("File: \(#file)")
                print("Line: \(#line)")
                print("invite failed")
            }
        }
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // vars
    var friends: [User] = []
    var cellSelected: [Bool] = []
    var group: Group = Group()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add back button
        self.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(pressBack))
        
        // add done button
        self.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(pressDone))

        // tableview setup
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
        // initialize cellSelected (all to false)
        for _ in SimpleData.Users {
            self.cellSelected.append(false)
        }
        
        // get list of invitable friends
        let id = self.group.id!
        
        Group.getInvite(group_id: id) { result in
            switch result{
            case .success(let friends):
                self.friends = friends
                self.tableView.reloadData()
            case .failure(_):
                print("File \(#file)")
                print("Line \(#line)")
                print("error getting friends")
            }
        }
        
    }

    // tableview stuff
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return self.pendingRequests.count
        return self.friends.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // height of cell
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("FriendTableViewCell", owner: self, options: nil)?.first as! FriendTableViewCell
        
        cell.labelName.text = self.friends[indexPath.row].name
        
        // check if check mark should be added
        if (self.cellSelected[indexPath.row]) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // unselect row
        tableView.deselectRow(at: indexPath, animated: true)
        
        // select or deselect (checkmark)
        self.cellSelected[indexPath.row] = !(self.cellSelected[indexPath.row])
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }

}
