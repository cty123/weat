//
//  RecommendedRestaurantsViewController.swift
//  Weat
//
//  Created by Jordan Barkley on 3/25/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import UIKit

class RecommendedRestaurantsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // action for closing button
    @IBAction func action(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // outlets
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    // variables
    var recommnedations: [Recommendation] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
        User.getUserInfo(profile_id: "3"){result in
            switch result {
            case .success(let user):
                self.recommnedations = user.recommendations
                self.tableView.reloadData()
            case .failure(_):
                print("File: \(#file)")
                print("Line: \(#line)")
                print("failed to get user")
            }
        }
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
        return self.recommnedations.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // default height of tableview cell
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // setup cell
        let cell = Bundle.main.loadNibNamed("RestaurantTableViewCell", owner: self, options: nil)?.first as! RestaurantTableViewCell
        let recommendation = self.recommnedations[indexPath.row]
        cell.labelName.text = "\(recommendation.friend_name) recommends \(recommendation.recommended_menu_item_name)"
        cell.labelDetail.text = "from \(recommendation.restaurant_name)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // unselect row
        tableView.deselectRow(at: indexPath, animated: true)
        
        /*
        // create vc
        let vc = FriendViewController(nibName: "FriendViewController", bundle: nil)
        vc.facebookLink = self.weatFriends[indexPath.row].facebook_link!
        self.present(vc, animated: true, completion: nil)
        */
        
 
    }
    
}
