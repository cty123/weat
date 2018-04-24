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
        
        // make orange
        self.navigationBar.makeOrange()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
        let id = UserDefaults.standard.string(forKey: "id")!
        User.getUserInfo(profile_id: id){result in
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
        
        self.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(action))
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
        cell.labelName.text = "\(String(describing: recommendation.friend_name!)) recommends \(String(describing: recommendation.restaurant_name!))"
        cell.labelDetail.text = "\(String(describing: recommendation.recommended_menu_item_name!))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // unselect row
        tableView.deselectRow(at: indexPath, animated: true)
        
        // get restaurant
        let recommendation = recommnedations[indexPath.row]
        
        /*
        let r = Restaurant()
        r.google_link = recommendation.google_link
        r.name = recommendation.restaurant_name
        */
        
        
        Restaurant.getRestaurantInfo(google_link: recommendation.google_link!, completion: { (restaurant: Restaurant) in
            restaurant.getRestaurant { result in
                switch result {
                case .success(_):
                    let vc = RestaurantViewController(nibName: "RestaurantViewController", bundle: nil)
                    vc.restaurant = restaurant
                    vc.back_string = "Back"
                    self.present(vc, animated: true, completion: nil)
                case .failure(let error):
                    print("getRestaurant error in listViewController")
                }
            }
        })
        
        
        
        /*
        r.getRestaurant() { status in
            if(status){
                // create vc
                Restaurant.getRestaurantInfo(google_link: r.google_link, completion: { (restaurant: Restaurant) in
 
                })
                
                let vc = RestaurantViewController(nibName: "RestaurantViewController", bundle: nil)
                self.present(vc, animated: true, completion: nil)
            }else{
                // don't create vc
                print("File \(#file)")
                print("Line \(#line)")
                print("failed to get restaruant")
            }
        }
        */
    }
    
}
