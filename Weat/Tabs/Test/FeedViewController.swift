//
//  FeedViewController.swift
//  Weat
//
//  Created by Sean Becker on 2/20/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var global_feed = Feed()
    var friends_feed = Feed()
    var your_feed = Feed()
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var seg: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!

    
    @IBAction func action() {
        self.handleRefresh()
        self.refreshControl.endRefreshing()
    }
    
    @IBAction func handleRefresh() {
        let user_id = UserDefaults.standard.object(forKey: "id") as! Int
        switch self.seg.selectedSegmentIndex {
        // TODO: Change this to occur on pull down
        case 0:
            Feed.getFeed(feed_type: "/all", user_id: String(user_id), completion: {
                (feed: Feed?) in
                guard let new_feed = feed else {
                    print("error")
                    return
                }
                self.global_feed = new_feed
                self.tableView.reloadData()
            })
            
        case 1:
            Feed.getFeed(feed_type: "/friends", user_id: String(user_id), completion: {
                (feed: Feed?) in
                guard let new_feed = feed else {
                    print("error")
                    return
                }
                self.friends_feed = new_feed
                self.tableView.reloadData()

            })
            
        default:
            Feed.getFeed(feed_type: "", user_id: String(user_id), completion: {
                (feed: Feed?) in
                guard let new_feed = feed else {
                    print("error")
                    return
                }
                self.your_feed = new_feed
                self.tableView.reloadData()
            })
        }
        
    }
    
    let segments = ["Global", "Friends", "Me"]
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(action), for: UIControlEvents.valueChanged)
        return refreshControl
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // color
        self.navigationBar.makeOrange()
        
        //
        let user_id = UserDefaults.standard.object(forKey: "id") as! Int
        
        // Load in friend feed
        Feed.getFeed(feed_type: "/friends", user_id: String(user_id), completion: {
            (feed: Feed?) in
            guard let new_feed = feed else {
                print("error")
                return
            }
            self.friends_feed = new_feed
            self.tableView.reloadData()
        })
        self.seg.setup(segmentNames: segments, color: UIColor.orange)
        self.seg.selectedSegmentIndex = 1
        
        // table view init
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        self.tableView.addSubview(self.refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // tableview stuff
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // feed = 0
        var count: Int = 5
        switch self.seg.selectedSegmentIndex {
        case 0:
            // global feed
            count = global_feed.dataUnarchived.count
        case 1:
            // friends feed
            count = friends_feed.dataUnarchived.count
        case 2:
            // your feed
            count = your_feed.dataUnarchived.count
        default:
            // should never happen
            break
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 44 is the standard height of a row
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("FeedTableViewCell", owner: self, options: nil)?.first as! FeedTableViewCell
        
        switch self.seg.selectedSegmentIndex {
        case 0: // global feed
            let feed_obj = global_feed.dataUnarchived[indexPath.row]
            cell.feed_obj = feed_obj
            cell.labelName.text = "\(String(describing: feed_obj.actor_name))"
            cell.labelRestaurant.text = "\(String(describing: feed_obj.restaurant_name))"
            cell.labelRating.text = "\(String(describing: feed_obj.feed_text))"
            return cell
            
        case 1: // friends feed
            let feed_obj = friends_feed.dataUnarchived[indexPath.row]
            cell.feed_obj = feed_obj
            cell.labelName.text = "\(String(describing: feed_obj.actor_name))"
            cell.labelRestaurant.text = "\(String(describing: feed_obj.restaurant_name))"
            cell.labelRating.text = "\(String(describing: feed_obj.feed_text))"
            return cell
            
        case 2: // your feed
            let feed_obj = your_feed.dataUnarchived[indexPath.row]
            cell.feed_obj = feed_obj
            cell.labelName.text = "\(String(describing: UserDefaults.standard.string(forKey: "name")!))"
            cell.labelRestaurant.text = "\(String(describing: feed_obj.restaurant_name))"
            cell.labelRating.text = "\(String(describing: feed_obj.feed_text))"
            return cell
            
        default: // should never happen
            return UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // keeps a row from being permenantly selected
        tableView.deselectRow(at: indexPath, animated: true)
        // get this cells' info
        let cell = tableView.cellForRow(at: indexPath) as! FeedTableViewCell
        // set new views' info
        let feedDetailViewController = FeedDetailViewController(nibName: "FeedDetailViewController", bundle: nil)
        feedDetailViewController.feed_obj = cell.feed_obj
        self.present(feedDetailViewController, animated: true, completion: nil)
    }

}
