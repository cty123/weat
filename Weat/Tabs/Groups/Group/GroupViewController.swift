//
//  GroupViewController.swift
//  Weat
//
//  Created by Jordan Barkley on 4/8/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import UIKit
import CoreLocation

class GroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {

    // outlets
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    // actions
    @IBAction func pressBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressEdit(_ sender: Any) {
        let vc = GroupDetailsViewController(nibName: "GroupDetailsViewController", bundle: nil)
        vc.group = self.group
        self.present(vc, animated: true, completion: nil)
    }
    
    // vars
    var group: Group = Group()
    let locationManager = CLLocationManager()
    var suggestions: [Restaurant] = []
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make orange
        self.navigationBar.makeOrange()
        
        // add back button
        self.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(pressBack))
        
        // add edit button
        self.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(pressEdit))
        
        // tableview setup
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
        self.tableView.addSubview(self.refreshControl)
        
        // locaiton manager setup
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        // get recommendations
        self.getSuggestions()
    }
    
    @IBAction func handleRefresh() {
        self.getSuggestions()
        self.refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // set title to group name
        self.navigationBar.topItem?.title = self.group.name
    }
    
    func getSuggestions() {
        // clear old suggestions
        self.suggestions = []
        // update recommendation
        let id = self.group.id!
        let location = self.locationManager.location!.coordinate
        
        print(location.latitude)
        print(location.longitude)
        
        Group.getRecommendation(group_id: id, latitude: location.latitude, longitude: location.longitude){ result in
            switch result {
            case .success(let restaurants):
                for ele in restaurants {
                    Restaurant.getRestaurantInfo(google_link: ele.google_link!) { (restaurant: Restaurant) in
                        restaurant.getRestaurantRating() { result in
                            switch result {
                            case .success(_):
                                self.suggestions.append(restaurant)
                                self.tableView.reloadData()
                            case .failure(let error):
                                print("File: \(#file)")
                                print("Line: \(#line)")
                                print(error)
                            }
                        }
                    }
                }
            case .failure(let error):
                print("File: \(#file)")
                print("Line: \(#line)")
                print("failed to get restaurant suggestions")
                print(error)
            }
        }
    }


    // tableview stuff
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.suggestions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // height of cell
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.suggestions.count < indexPath.row + 1 {
            return UITableViewCell()
        }
        
        let cell = Bundle.main.loadNibNamed("RestaurantTableViewCell", owner: self, options: nil)?.first as! RestaurantTableViewCell
        
        let list_obj = suggestions[indexPath.row]
        
        let rank = indexPath.row + 1
        cell.labelRank.text = "\(rank)"
        cell.labelName.text = "\(String(describing: list_obj.name!))"
        if (list_obj.image != nil) {
            cell.imageViewPic.image = list_obj.image!
            cell.imageViewPic.layer.cornerRadius = cell.imageViewPic.frame.size.height / 2;
            cell.imageViewPic.layer.masksToBounds = true;
        }
        
        // ratings calculation
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
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // deselect row
        tableView.deselectRow(at: indexPath, animated: true)
        
        // go to restaurant view
        let vc = RestaurantViewController(nibName: "RestaurantViewController", bundle: nil)
        vc.restaurant = suggestions[indexPath.row]
        self.present(vc, animated: true, completion: nil)
        
    }

}
