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
    @IBOutlet weak var friendOrangeDot: UIImageView!
    @IBOutlet weak var recommendLabel: UILabel!
    @IBOutlet weak var recommendOrangeDot: UIImageView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    
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
    
    @IBAction func handleRefresh() {
        switch self.segmentedControl.selectedSegmentIndex {
        
        // feed
        case 0:
            Feed.getFeed(feed_type: "", completion: {
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
            let id = String(describing: UserDefaults.standard.integer(forKey: "id"))
            
            Friend.getFriends(profile_id: id){ result in
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
            let id = UserDefaults.standard.string(forKey: "id")!
            User.getUserInfo(profile_id: id){result in
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
    
    @IBAction func segmentValueChanged(_ sender: Any) {
        self.handleRefresh()
    }
    
    // vars
    var friendLinks: [String] = []          // array of friends' facebook user_id
    var friends: [User] = []                // array of friends
    var personalFeed: Feed? = nil           // feed
    var showArchivedFeedItems = false       // toggle to allow user to see archived feed items
    var favorites: [Restaurant] = []
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    // segmented control segments
    let segments = ["Feed", "Friends", "Favorites"]
    
    // update name location
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.recommendLabel.text = "0"
        
        // update showArchivedFeedItems
        let showArchived = UserDefaults.standard.bool(forKey: "showArchived")
        self.showArchivedFeedItems = showArchived
        
        // Set profile text
        let id = UserDefaults.standard.string(forKey: "id")
        User.getUserInfo(profile_id: id!){result in
            switch result {
                case .success(let user):
                    self.labelName.text = user.name
                    self.labelLocation.text = user.location
                    self.recommendLabel.text = "\(user.recommendations.count)"
                    if(user.recommendations.count > 0) {
                        self.recommendOrangeDot.image = UIImage(named: "OrangeDot")
                    }
                case .failure(let error):
                    
                    print(error)
            }
        }
        
        
        // Set notifications format
        self.notificationsLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        self.buttonViewFriendRequests.addFullWidthBottomBorderWithColor(color: UIColor.lightGray, width: 0.4)
        
        // Get friend requests
        Friend.pullFriendRequest(){ result in
            switch result{
            case .success(let requests):
                self.friendRequestCountLabel.text = "\(requests.count)"
                
                // Set global friend requests variable
                profileVars.friendRequests = requests
                
                if (requests.count > 0) {
                    self.friendOrangeDot.image = UIImage(named: "OrangeDot")
                } else {
                    self.friendOrangeDot.image = nil
                }
            case .failure(let error):
                print("File: \(#file)")
                print("Line: \(#line)")
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make orange
        self.navigationBar.makeOrange()
        
        // get feed
        self.handleRefresh()
        
        // add pull to refresh
        self.tableView.addSubview(self.refreshControl)

        // init segmented control
        self.segmentedControl.setup(segmentNames: segments, color: UIColor.orange)
        
        // init button
        self.buttonEdit.setup(title: "Edit Profile", color: UIColor.orange)
        //self.buttonViewFriendRequests.setup(title: "Friend Requests", color: UIColor.orange)
        
        // table view init
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
        //  profile picture
        self.imageViewProfilePicture.setFacebookProfilePicture(facebook_link: "me")
        
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
                // if feed not nil, check if showArchived
                if (self.showArchivedFeedItems) {
                    // return all data
                    return ret.data.count
                } else {
                    // return unarchived data
                    return ret.dataUnarchived.count
                }
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
            
            if (check.data.count == 0) {
                // lazy check
                return UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
            }
            
            if (self.showArchivedFeedItems) {
                feed_obj = check.data[indexPath.row]
            } else {
                feed_obj = check.dataUnarchived[indexPath.row]
            }
        } else {
            // this might cause a crash, hopefully not
            feed_obj = FeedElement(feed_obj: "")
        }
    
        let cell = Bundle.main.loadNibNamed("FeedTableViewCell", owner: self, options: nil)?.first as! FeedTableViewCell

        switch self.segmentedControl.selectedSegmentIndex {
        case 0: // feed
            cell.labelName.text = UserDefaults.standard.string(forKey: "name")
            cell.labelRestaurant.text = feed_obj.restaurant_name
            cell.labelRating.text = feed_obj.feed_text
            return cell
            
        case 1: // friends
            let cell = Bundle.main.loadNibNamed("FriendTableViewCell", owner: self, options: nil)?.first as! FriendTableViewCell
            cell.labelName.text = self.friends[indexPath.row].name
            return cell
            
        case 2: // favorites
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
    
    /// delete stuff
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    
        // only for Feed
        if (self.segmentedControl.selectedSegmentIndex == 0) {
            // disable ability to archive an archived item
            return !self.showArchivedFeedItems
        }
        
        // for Favorites, Friends
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {

            if (self.showArchivedFeedItems) {
                // do nothing!!!
            } else {
                // archive
                let id = String(personalFeed!.dataUnarchived[indexPath.row].feed_id)
                Feed.archiveFeedItem(feed_id: id, completion: { status in
                    if (status) {
                        print("Archive was succesful")
                        self.personalFeed?.dataUnarchived.remove(at: indexPath.row)
                        self.tableView.reloadData()
                    } else {
                        print("File: \(#file)")
                        print("Line: \(#line)")
                        print("Archive failed")
                    }
                })
            }

        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Archive"
    }
    /// delete stuff
    
}
