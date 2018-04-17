//
//  GroupDetailsViewController.swift
//  Weat
//
//  Created by Jordan Barkley on 4/8/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import UIKit

class GroupDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // outlets
    @IBOutlet weak var textFieldGroupName: UITextField!
    @IBOutlet weak var tableViewMembers: UITableView!
    @IBOutlet weak var buttonIcon: UIButton!
    @IBOutlet weak var buttonInvite: UIButton!
    @IBOutlet weak var buttonLeave: UIButton!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    // actions
    @IBAction func pressDone(_ sender: Any) {
        
        // change group name (backend)
        var name: String = ""
        if let _ = self.textFieldGroupName.text {
            name = self.textFieldGroupName.text!
        }
        let id      = self.group.id!
        let icon_id = self.group.icon_id!
        
        Group.edit(group_id: id, group_name: name, group_icon_id: icon_id){ result in
            print("File: \(#file)")
            print("Line: \(#line)")
            if result {
                print("edit group success")
            } else {
                print("edit group failure")
            }
        }
        
        // change group name (frontend)
        let pvc = self.presentingViewController as! GroupViewController
        pvc.group.name = name
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressIcon(_ sender: Any) {
        let vc = GroupIconViewController(nibName: "GroupIconViewController", bundle: nil)
        vc.group = self.group
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func pressInvite(_ sender: Any) {
        let vc = GroupInviteViewController(nibName: "GroupInviteViewController", bundle: nil)
        vc.group = self.group
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func pressLeave(_ sender: Any) {
        
        // leave group on backend
        let id = self.group.id!
        Group.leave(group_id: id){result in
            print("File: \(#file)")
            print("Line: \(#line)")
            if result{
                print("left group")
            } else {
                print("failed to leave group")
            }
        }
        
        // dismis details vc
        self.dismiss(animated: true, completion: nil)
        
        // dismiss this group vc
        let pvc = self.presentingViewController as! GroupViewController
        pvc.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func pressDelete(_ sender: Any) {
        
        let id = self.group.id!
        
        Group.destroy(group_id: id) { result in
            print("File: \(#file)")
            print("Line: \(#line)")
            
            if result {
                print("deleted group")
            } else {
                print("failed to delete group")
            }
        }
        
        // dismis details vc
        self.dismiss(animated: true, completion: nil)
        
        // dismiss this group vc
        let pvc = self.presentingViewController as! GroupViewController
        pvc.dismiss(animated: true, completion: nil)
    }
    
    
    // vars
    var group: Group = Group()
    var members: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let id = self.group.id!
        
        // check if user is group owner
        Group.isOwner(group_id: id) { result in
            
            // make sure only the owner can delete
            if result {
                self.buttonDelete.isEnabled = true
            } else {
                self.buttonDelete.isEnabled = false
            }
        }
        
        // set textfield to group name
        self.textFieldGroupName.text = self.group.name
        
        Group.getMembers(group_id: id){ result in
            print("File: \(#file)")
            print("Line: \(#line)")
            switch result{
            case .success(let users):
                print("got users successfully")
                self.members = users
                print(users)
                self.tableViewMembers.reloadData()
            case .failure(_):
                print("failed to get users")
            }
        }
        
        // setup buttons
        self.buttonIcon.setup(title: "Change Group Icon", color: .orange)
        self.buttonInvite.setup(title: "Invite to Group", color: .orange)
        self.buttonLeave.setup(title: "Leave Group", color: .orange)
        self.buttonDelete.setup(title: "Delete Group", color: .red)
        
        // add back button
        self.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(pressDone))
        
        // tableview setup
        self.tableViewMembers.delegate = self
        self.tableViewMembers.dataSource = self
        self.tableViewMembers.reloadData()
    }
    
    // tableview stuff
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return self.pendingRequests.count
        return self.members.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // height of cell
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("FriendTableViewCell", owner: self, options: nil)?.first as! FriendTableViewCell
        cell.labelName.text = self.members[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // unselect row
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
