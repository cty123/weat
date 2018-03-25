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
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBAction func pressCancel(_ sender: UIBarButtonItem) {
        // exit vc
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressRecommend(_ sender: UIBarButtonItem) {
        // recommend to all selected users
        let googleLink = self.restaurant.google_link!
        let menuItemID = 0 // TODO: menuItemsID
        let restaurantName = restaurant.name!
        var friendIDs: String = ""
        
        
        // cycle through friends to get their friend ids
        var i = 0
        for friend in self.friends {
            if (cellSelected[i]) {
                // if cell selected, add friend id with a comma
                friendIDs = friendIDs + "\(friends[i].id!),"
            }
            
            // increment i
            i = i + 1
        }
        
        Recommendation.sendRecommendation(google_link: googleLink, menu_item_id: menuItemID, restaurant_name: restaurantName, friend_ids: friendIDs){status in
            if status {
            }else {
                // This request should not fail
            }
        }
        
        // exit vc
        self.dismiss(animated: true, completion: nil)

    }
    
    // vars
    var friends: [User] = []
    var cellSelected: [Bool] = []
    var restaurant: Restaurant = Restaurant()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add cancel button
        self.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(pressCancel))
        
        // add recommend button
        self.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Recommend", style: .plain, target: self, action: #selector(pressRecommend))
        
        // initialize cellSelected (all to false)_
        for _ in SimpleData.Users {
            cellSelected.append(false)
        }
        
        // get friends
        Friend.getFriends(profile_id: UserDefaults.standard.string(forKey: "id")!){ result in
            switch result{
            case .success(let friends):
                self.friends = friends
            case .failure(_):
                print("File: \(#file)")
                print("Line: \(#line)")
                print("failed to get [Weat.Friend]")

            }
        }
    
        // tableview data
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    
    

    // tableview stuff
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends.count
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
        cell.labelName.text = self.friends[indexPath.row].name
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
