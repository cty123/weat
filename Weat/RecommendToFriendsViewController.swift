//
//  RecommendToFriendsViewController.swift
//  Weat
//
//  Created by Jordan Barkley on 3/13/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import UIKit

class RecommendToFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    // vars
    // var friends: [Users]
    var cellSelected: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // initialize cellSelected (all to false)_
        for _ in SimpleData.Users {
            cellSelected.append(false)
        }
    
        // reload tableview data
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    

    // tableview stuff
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return self.pendingRequests.count
        // TODO: actual data
        return SimpleData.Users.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // height of standard cell
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // init cell
        let cell = Bundle.main.loadNibNamed("FriendTableViewCell", owner: self, options: nil)?.first as! FriendTableViewCell

        // check if check mark should be added
        if (self.cellSelected[indexPath.row]) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        // set label to name
        cell.labelName.text = SimpleData.Users[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // unselect row (the grey highilight)
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        // select or deselect (checkmark)
        self.cellSelected[indexPath.row] = !(self.cellSelected[indexPath.row])
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }


}
