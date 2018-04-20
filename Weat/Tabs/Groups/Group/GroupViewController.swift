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
    var recommendations: [Restaurant] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add back button
        self.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(pressBack))
        
        // add edit button
        self.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(pressEdit))
        
        // tableview setup
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
        
        // locaiton manager setup
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        // get recommendations
        self.getRecommendation()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // set title to group name
        self.navigationBar.topItem?.title = self.group.name
    }
    
    func getRecommendation() {
        // update recommendation
        let id = self.group.id!
        let location = self.locationManager.location!.coordinate
        
        print(location.latitude)
        print(location.longitude)
        
        Group.getRecommendation(group_id: id, latitude: location.latitude, longitude: location.longitude){ result in
            switch result {
            case .success(let restaurants):
                print(restaurants)
                self.recommendations = restaurants
                self.tableView.reloadData()
            case .failure(let error):
                print("File: \(#file)")
                print("Line: \(#line)")
                print("failed to get restaurant recommendations")
                print(error)
            }
        }
    }


    // tableview stuff
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recommendations.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // height of cell
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.recommendations[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // deselect row
        tableView.deselectRow(at: indexPath, animated: true)
        
        // go to restaurant view
        let vc = RestaurantViewController(nibName: "RestaurantViewController", bundle: nil)
        vc.restaurant = recommendations[indexPath.row]
        self.present(vc, animated: true, completion: nil)
        
    }

}
