//
//  ProfileMainViewController.swift
//  Weat
//
//  Created by admin on 2/18/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import SwiftyJSON

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // outlets
    @IBOutlet weak var imageViewProfilePicture: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonViewFriendRequests: UIButton!
    @IBOutlet weak var friendRequestLabel: UILabel!
    @IBOutlet weak var friendRequestCountLabel: UILabel!
    @IBOutlet weak var notificationsLabel: UILabel!
    @IBOutlet weak var restaurantOrangeDot: UIImageView!
    @IBOutlet weak var friendOrangeDot: UIImageView!
    
    
    @IBAction func viewFriendRequests(_ sender: Any) {
        // open next view controller
        let friendRequestsViewController = FriendRequestsViewController(nibName: "FriendRequestsViewController", bundle: nil)
        self.present(friendRequestsViewController, animated: true, completion: nil)
    }
    
    @IBAction func pressEdit(_ sender: Any) {
        let editProfileViewController = EditProfileViewController(nibName: "EditProfileViewController", bundle: nil)
        self.present(editProfileViewController, animated: true, completion: nil)
    }
    
    @IBAction func addFriendsButtonPress(_ sender: UIButton) {
        let findFriendsViewController = FindFriendsViewController(nibName: "FindFriendsViewController", bundle: nil)
        self.present(findFriendsViewController, animated: true, completion: nil)
    }
    
    @IBAction func pressRecommendedRestaurants(_ sender: Any) {
        let vc = RecommendedRestaurantsViewController(nibName: "RecommendedRestaurantsViewController", bundle: nil)
        self.present(vc, animated: true, completion: nil)
    }
    
    
    // vars
    var friendLinks: [String] = []          // array of friends' facebook user_id
    var friends: [User] = []                // array of friends
    var personalFeed: Feed? = nil           // feed
    var showArchivedFeedItems = false       // toggle to allow user to see archived feed items
    var favorites: [Favorite] = []
    
    // segmented control segments
    let segments = ["Feed", "Friends", "Favorites"]
    
    // update name location (TODO: remove this)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set profile text
        let id = UserDefaults.standard.string(forKey: "id")
        
        User.getUserInfo(profile_id: id!){result in
            switch result {
                case .success(let user):
                    self.labelName.text = user.name
                    self.labelLocation.text = user.location
                case .failure(let error):
                    print(error)
                    /*
                        * Handle error here
                        */
            }
        }
        
        
        // Set notifications format
        self.notificationsLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        self.buttonViewFriendRequests.addFullWidthBottomBorderWithColor(color: UIColor.lightGray, width: 0.4)
        
        restaurantOrangeDot.image = UIImage(named: "OrangeDot") // Only really do this when we have a notification
        
        // Get friend requests
        Friend.pullFriendRequest(){ result in
            switch result{
            case .success(let requests):
                self.friendRequestCountLabel.text = "\(requests.count)"
                
                // Set global friend requests variable
                profileVars.friendRequests = requests
                
                if(requests.count > 0) {
                    self.friendOrangeDot.image = UIImage(named: "OrangeDot")
                } else {
                    self.friendOrangeDot.image = nil
                }
            case .failure(let error):
                print(error)
                /*
                    * Handle error here
                    */
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get friends
        let id = String(describing: UserDefaults.standard.integer(forKey: "id"))
        
        Friend.getFriends(profile_id: id){ result in
            switch result{
            case .success(let friends):
                self.friends = friends
            case .failure(_):
                print("File \(#file)")
                print("Line \(#line)")
                print("error getting friends")

            }
        }
    
        
        // init segmented control
        self.segmentedControl.setup(segmentNames: segments, color: UIColor.orange)
        
        // init button
        self.buttonEdit.setup(title: "Edit Profile", color: UIColor.orange)
        //self.buttonViewFriendRequests.setup(title: "Friend Requests", color: UIColor.orange)
        
        // table view init
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
        // populate profile
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, location, picture.type(large)"]).start(completionHandler: { (connection, result, error) -> Void in
            if (error == nil){
                
                

                print(result as Any)
                
                // get json
                let json = JSON(result!)
                
                // profile picture
                let urlString: String = json["picture","data","url"].string!
                let url = URL(string: urlString)
                if let data = try? Data(contentsOf: url!) {
                    self.imageViewProfilePicture.image = UIImage(data: data)!
                    // Make image circular
                    self.imageViewProfilePicture.layer.cornerRadius = self.imageViewProfilePicture.frame.size.height / 2;
                    self.imageViewProfilePicture.layer.masksToBounds = true;
                    self.imageViewProfilePicture.layer.borderWidth = 0;
                }
                
                // name
                // self.labelName.text = json["name"].string!
                
                // location
                // ?
                
                
            } else {
                

                print(error as Any)
            }
        })
        
    }
    
    // when the segment is changed
    @IBAction func segmentChanged(_ sender: Any) {
        
        // TODO: pull to refresh instead
        switch self.segmentedControl.selectedSegmentIndex {
        case 0: // feed
            /*
            Feed.getFeed(feed_type: "/friends", completion: {
                (feed: Feed?) in
                guard let new_feed = feed else {
                    return
                }
                self.personalFeed = new_feed
            })
            */
            break
        default:
            break
        }
        
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
            if (self.showArchivedFeedItems) {
                // return self.personalFeed?.data.count
            } else {
                // return self.personalFeed?.unarchivedData.count
            }
            return 10
        case 1:
            return self.friends.count
        case 2:
            // favorites, TODO: user.favorites.size
            break
        default:
            // should never happend
            break
        }
        
        // just return 0 otherwise
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
            
            if (self.showArchivedFeedItems) {
                cell.labelName.text = self.personalFeed?.data[indexPath.row].actor_name
                cell.labelName.text = self.personalFeed?.data[indexPath.row].restaurant_name
            } else {
                cell.labelName.text = self.personalFeed?.dataUnarchived[indexPath.row].actor_name
                cell.labelName.text = self.personalFeed?.dataUnarchived[indexPath.row].restaurant_name
            }
            
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
        // friends: open next view controller
        if (self.segmentedControl.selectedSegmentIndex == 1) {
            let friendViewController = FriendViewController(nibName: "FriendViewController", bundle: nil)
            // todo facebook id
            friendViewController.facebookLink = "1493264010796475"
            friendViewController.weatID = String(describing: friends[indexPath.row].id)
            self.present(friendViewController, animated: true, completion: nil)
        }
        
        // unselect row
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /// delete stuff
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // self.personalFeed?.unarchivedData.remove(at: indexPath.row)
            // TODO: archive here not just remove for show
            

            print("deleted this cell i guess \(indexPath.row)")
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Archive"
    }
    /// delete stuff
    
}
