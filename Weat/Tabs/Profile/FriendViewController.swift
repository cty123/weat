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
    
    @IBAction func handleRefresh() {
        switch self.segmentedControl.selectedSegmentIndex {
            
        // feed
        case 0:
            Feed.getFeed(feed_type: "", user_id: String(user!.id!), completion: {
                (feed: Feed?) in
                guard let new_feed = feed else {
                    print("error")
                    self.refreshControl.endRefreshing()
                    return
                }
                self.personalFeed = new_feed
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                
            })
            break
            
        // friends
        case 1:
            
            Friend.getFriends(profile_id: String(user!.id!)){ result in
                switch result{
                case .success(let friends):
                    self.friends = friends
                    self.tableView.reloadData()
                case .failure(_):
                    print("File \(#file)")
                    print("Line \(#line)")
                    print("error getting friends")
                }
                self.refreshControl.endRefreshing()
            }
            
        // favorites
        case 2:
            User.getUserInfo(profile_id: String(user!.id!)){result in
                switch result {
                case .success(let user):
                    self.favorites = []
                    for ele in user.favorites {
                        Restaurant.getRestaurantInfo(google_link: ele.google_link!) { (restaurant: Restaurant) in
                            restaurant.getRestaurantRating() { result in
                                switch result {
                                case .success(_):
                                    self.favorites.append(restaurant)
                                    self.tableView.reloadData()
                                case .failure(let error):
                                    print("File: \(#file)")
                                    print("Line: \(#line)")
                                    print(error)
                                }
                            }
                        }
                        
                    }
                    
                    self.tableView.reloadData()
                case .failure(_):
                    print("File: \(#file)")
                    print("Line: \(#line)")
                    print("failed to get user favorites")
                }
                self.refreshControl.endRefreshing()
            }
            
        // default
        default:
            break
        }
    }

    @IBAction func friendButtonPress(_ sender: UIButton) {
        let friend_id: String = "\((user?.id)!)"
        switch(friend_status!) {
        case -1:
            Friend.sendFriendRequest(friend_id: friend_id) { result in
                switch result {
                case .success(_):
                    self.buttonAddFriend.setTitle("Remove Request", for: UIControlState.normal)
                    self.friend_status = 2
                    // Alert the user
                    let alert = UIAlertController(title: "Success", message: "Sent friend request", preferredStyle: UIAlertControllerStyle.alert)
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                case .failure(let error):
                    switch error{
                    case RequestError.alreadySent(let msg):
                        // Alert the user
                        let alert = UIAlertController(title: "Send Request", message: msg, preferredStyle: UIAlertControllerStyle.alert)
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                    default:
                        print("File: \(#file)")
                        print("Line: \(#line)")
                        print("Failed to send friend request.")
                    }
                }
            }
        case 0,1:
            Friend.remove(id: friend_id, completion: { (result) in
                var title: String
                var message: String
                switch(result) {
                case .success:
                    title = "Success"
                    message = "Removed friend"
                    self.buttonAddFriend.setTitle("Add Friend", for: UIControlState.normal)
                    self.friend_status = -1
                case .failure(let error):
                    title = "Error"
                    message = "\(error)"
                }
                let alert = UIAlertController(title: title,
                                              message: message,
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Done",
                                              style: .default,
                                              handler: nil))
                self.present(alert, animated: true, completion: nil)
            })
        default:
            break
        }
        
    }
    // init with this view
    var user: User?
    var friends: [User] = []            // array of friend
    var friend_status: Int?
    var favorites: [Restaurant] = []
    var personalFeed: Feed? = nil
    let segments = ["Feed", "Friends", "Favorites"]
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make orange
        self.navigationBar.makeOrange()
        
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
        
        /*---- populate profile ----*/
        
        // User details
        self.labelName.text = user?.name!
        self.labelLocation.text = user?.location!
        
        // Add/remove friend text
        let user_id = "\((user?.id)!)"
        Friend.getStatus(id: user_id) { (result) in
            switch result{
            case .success(let status):
                print("\(status)")
                switch status{
                // Pending
                case -1:
                    self.buttonAddFriend.setTitle("Add Friend", for: UIControlState.normal)
                case 0:
                    self.buttonAddFriend.setTitle("Remove Request", for: UIControlState.normal)
                case 1:
                    self.buttonAddFriend.setTitle("Remove Friend", for: UIControlState.normal)
                case 2:
                    // Friend denied... not sure what to show
                    self.buttonAddFriend.setTitle("User blocked you...", for: UIControlState.normal)
                    break
                default:
                    break
                }
                self.friend_status = status
            case .failure(_):
                print("File: \(#file)")
                print("Line: \(#line)")
                print("Failed to obtain relationship status")
            }
        }
        
        // set facebook profile picture
        self.imageViewProfilePic.setFacebookProfilePicture(facebook_link: user!.facebook_link!)
        
        // tableview stuff
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.addSubview(self.refreshControl)
        self.handleRefresh()

        
    }
    
    
    
    // when the segment is changed
    @IBAction func segmentChanged(_ sender: Any) {
        self.handleRefresh()
    }
    
    // tableview stuff
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // feed = 0
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            // check if feed is valid
            if let ret = self.personalFeed {
                return ret.dataUnarchived.count
            } else {
                // if feed nil, return 0
                return 0
            }
        case 1:
            return self.friends.count
        case 2:
            return self.favorites.count
        default:
            // should never happend
            break
        }
        
        // just return 0 otherwise
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 44 is the standard height of a row
        if self.segmentedControl.selectedSegmentIndex == 2 {
            let cell = Bundle.main.loadNibNamed("RestaurantTableViewCell", owner: self, options: nil)?.first as! RestaurantTableViewCell
            return cell.frame.height
        } else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // check
        var feed_obj: FeedElement
        if let check = self.personalFeed {
            
            if (check.dataUnarchived.count == 0) {
                // lazy check
                return UITableViewCell()
            }
            
            feed_obj = check.dataUnarchived[indexPath.row]
            
            
        } else {
            // this might cause a crash, hopefully not
            feed_obj = FeedElement(feed_obj: "")
        }
        
        let cell = Bundle.main.loadNibNamed("FeedTableViewCell", owner: self, options: nil)?.first as! FeedTableViewCell
        
        switch self.segmentedControl.selectedSegmentIndex {
        case 0: // feed
            cell.labelName.text = (user?.name)!
            cell.labelRestaurant.text = feed_obj.restaurant_name
            cell.labelRating.text = feed_obj.feed_text
            return cell
            
        case 1: // friends
            if (self.friends.count == 0) {
                return UITableViewCell()
            }
            let cell = Bundle.main.loadNibNamed("FriendTableViewCell", owner: self, options: nil)?.first as! FriendTableViewCell
            cell.labelName.text = self.friends[indexPath.row].name
            cell.imageViewPic.setFacebookProfilePicture(facebook_link: self.friends[indexPath.row].facebook_link!)
            return cell
            
        case 2: // favorites
            if (self.favorites.count == 0) {
                return UITableViewCell()
            }
            let cell = Bundle.main.loadNibNamed("RestaurantTableViewCell", owner: self, options: nil)?.first as! RestaurantTableViewCell
            let restaurant = favorites[indexPath.row]
            cell.labelName.text = restaurant.name
            
            
            // sean code start
            let list_obj = self.favorites[indexPath.row]
            
            if (list_obj.image != nil) {
                cell.imageViewPic.image = list_obj.image!
                cell.imageViewPic.layer.cornerRadius = cell.imageViewPic.frame.size.height / 2;
                cell.imageViewPic.layer.masksToBounds = true;
            }
            
            var food_rating: Float = 0.0
            var service_rating: Float = 0.0
            
            if(list_obj.rating.food_count_all > 0) {
                food_rating = (Float(list_obj.rating.food_good_all) / Float(list_obj.rating.food_count_all)) * 100
            }
            if(list_obj.rating.service_count_all > 0) {
                service_rating = (Float(list_obj.rating.service_good_all) / Float(list_obj.rating.service_count_all)) * 100
            }
            
            let overall_rating = Int((service_rating + food_rating) / 2.0)
            if (list_obj.rating.food_count_all == 0 && list_obj.rating.service_count_all == 0) {
                cell.labelDetail.text = "No ratings yet"
            } else {
                cell.labelDetail.text = "\(overall_rating)% of users recommend"
            }
            cell.restaurant = list_obj
            // sean code end
            
            cell.labelRank.text = nil
            
            return cell
            
        default: // should never happend
            return UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // friends: open next view controller
        if (self.segmentedControl.selectedSegmentIndex == 1) {
            let friendViewController = FriendViewController(nibName: "FriendViewController", bundle: nil)
            // todo facebook id
            friendViewController.user = self.friends[indexPath.row]
            self.present(friendViewController, animated: true, completion: nil)
        }
        
        // favorites: open next view controller
        if (self.segmentedControl.selectedSegmentIndex == 2) {
            let restaurant = self.favorites[indexPath.row]
            Restaurant.getRestaurantInfo(google_link: restaurant.google_link!, completion: { (restaurant: Restaurant) in
                restaurant.getRestaurant { result in
                    switch result {
                    case .success(_):
                        let vc = RestaurantViewController(nibName: "RestaurantViewController", bundle: nil)
                        vc.restaurant = restaurant
                        vc.back_string = "Back"
                        self.present(vc, animated: true, completion: nil)
                    case .failure(let error):
                        print("File: \(#file)")
                        print("Line: \(#line)")
                        print("failed to get restaruant details")
                        print(error)
                    }
                }
            })
        }
        
        // unselect row
        tableView.deselectRow(at: indexPath, animated: true)
    }


}
