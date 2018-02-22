//
//  TestViewController.swift
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
    
    @IBOutlet weak var seg: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func action(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        // TODO: Change this to occur on pull down
        case 0:
            Feed.getFeed(feed_type: "/all", completion: {
                (feed: Feed?) in
                guard let new_feed = feed else {
                    print("error")
                    return
                }
                self.global_feed = new_feed
                self.tableView.reloadData()
            })
            
        case 1:
            Feed.getFeed(feed_type: "/friends", completion: {
                (feed: Feed?) in
                guard let new_feed = feed else {
                    print("error")
                    return
                }
                self.friends_feed = new_feed
                self.tableView.reloadData()
            })
            
        default:
            Feed.getFeed(feed_type: "", completion: {
                (feed: Feed?) in
                guard let new_feed = feed else {
                    print("error")
                    return
                }
                self.your_feed = new_feed
                self.tableView.reloadData()
            })
        }
        
        tableView.reloadData()
    }
    
    let segments = ["Everyone", "Friends", "You"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load in friend feed
        Feed.getFeed(feed_type: "/friends", completion: {
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
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
            // global feed, TODO: set page size
            count = global_feed.data.count
        case 1:
            // friends feed
            count = friends_feed.data.count
        case 2:
            // your feed
            count = your_feed.data.count
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
            
            /* var restaurant_name: String
             var restaurant_id: Int
             
             var feed_text: String
             var feed_id: Int
             var createdAt: Int
             
             var actor_name: String
             var actor_id: Int
             
             var receiver_name: String
             var receiver_id: Int*/
        case 0: // global feed
            let feed_obj = global_feed.data[indexPath.row]
            
            cell.labelName.text = "\(String(describing: feed_obj.actor_name))"
            cell.labelRestaurant.text = "\(String(describing: feed_obj.restaurant_name))"
            cell.labelDate.text = "Dummy Date"
            cell.labelRating.text = "Dummy Rating"
            return cell
            
        case 1: // friends feed
            let feed_obj = friends_feed.data[indexPath.row]
            
            cell.labelName.text = "\(String(describing: feed_obj.actor_name))"
            cell.labelRestaurant.text = "\(String(describing: feed_obj.restaurant_name))"
            cell.labelDate.text = "Dummy Date"
            cell.labelRating.text = "Dummy Rating"
            return cell
            
        case 2: // your feed
            let feed_obj = your_feed.data[indexPath.row]
            cell.labelName.text = "\(String(describing: UserDefaults.standard.string(forKey: "name")!))"
            cell.labelRestaurant.text = "\(String(describing: feed_obj.restaurant_name))"
            cell.labelDate.text = "Dummy Date"
            cell.labelRating.text = "Dummy Rating"
            return cell
            
        default: // should never happen
            return UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // keeps a row from being permenantly selected
        tableView.deselectRow(at: indexPath, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
