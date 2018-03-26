//
//  FriendViewController.swift
//  Weat
//
//  Created by Jordan Barkley on 2/22/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import SwiftyJSON

class FriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // outlets
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var imageViewProfilePic: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var buttonAddFriend: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // action for closing button
    @IBAction func action(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func friendButtonPress(_ sender: UIButton) {
        let friend_id: String = "\((user?.id)!)"
        Friend.sendFriendRequest(friend_id: friend_id) { (status) in
            if(!status) {
                print("File: \(#file)")
                print("Line: \(#line)")
                print("Failed to send friend request.")
            }
        }
    }
    // init with this view
    var user: User?
    var friends: [User] = []            // array of friend
    
    
    // segmented control segments
    let segments = ["Feed", "Friends", /*"Favorites"*/]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // init segmented control
        self.segmentedControl.setup(segmentNames: segments, color: UIColor.orange)
        
        // init add friend button
        self.buttonAddFriend.setup(title: "Add Friend", color: UIColor.orange)
        
        // add close button
        navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(action))
        
        // table view init
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        /// populate profile
        
        // 1. profile picture
        FBSDKGraphRequest(graphPath: (self.user?.facebook_link)!, parameters: ["fields": "name, location, picture.type(large)"]).start(completionHandler: { (connection, result, error) -> Void in
            if (error == nil){

                print(result as Any)
                
                // get json
                let json = JSON(result!)
                
                // profile picture
                let urlString: String = json["picture","data","url"].string!
                let url = URL(string: urlString)
                if let data = try? Data(contentsOf: url!) {
                    self.imageViewProfilePic.image = UIImage(data: data)!
                    self.imageViewProfilePic.layer.cornerRadius = self.imageViewProfilePic.frame.size.height / 2;
                    self.imageViewProfilePic.layer.masksToBounds = true;
                    self.imageViewProfilePic.layer.borderWidth = 0;
                }
                
            } else {
                print(error as Any)
            }
        })
        
        self.labelName.text = user?.name!
        self.labelLocation.text = user?.location!

        
    }
    
    // when the segment is changed
    @IBAction func segmentChanged(_ sender: Any) {
        tableView.reloadData()
    }
    
    // tableview stuff
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // feed = 0
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            // feed, TODO: set page size
            

            print("FEED")
        case 1:
            // friends, TODO: user.friends.size
            

            print("FRIENDS")
            return self.friends.count
        case 2:
            // favorites, TODO: user.favorites.size
            

            print("FAVORITES")
        default:
            // should never happend
            break
        }
        
        // return 0 otherwise
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 44 is the standard height of a row
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: images
        switch self.segmentedControl.selectedSegmentIndex {
            
        case 0: // feed
            let cell = Bundle.main.loadNibNamed("FeedTableViewCell", owner: self, options: nil)?.first as! FeedTableViewCell
            cell.labelName.text = "\(String(describing: SimpleData.Users[indexPath.row]))"
            cell.labelRestaurant.text = "Dummy Restaurant"
            return cell
            
        case 1: // friends
            let cell = Bundle.main.loadNibNamed("FriendTableViewCell", owner: self, options: nil)?.first as! FriendTableViewCell
            cell.labelName.text = self.friends[indexPath.row].name
            return cell
            
        case 2: // favorites
            let cell = Bundle.main.loadNibNamed("RestaurantTableViewCell", owner: self, options: nil)?.first as! RestaurantTableViewCell
            cell.labelName.text = "\(String(describing: SimpleData.Restaurants[indexPath.row]))"
            cell.labelDetail.text = "\(arc4random_uniform(101))% of people recommend"
            return cell
            
        default: // should never happend
            return UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // open next view controller
        let friendViewController = FriendViewController(nibName: "FriendViewController", bundle: nil)
        friendViewController.user = friends[indexPath.row]
        self.present(friendViewController, animated: true, completion: nil)
        
        // unselect row
        tableView.deselectRow(at: indexPath, animated: true)
    }


}
