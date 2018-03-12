//
//  CheckinViewController.swift
//  Weat
//
//  Created by Sean Becker on 2/20/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class CheckinViewController: UIViewController {
    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var locationManager = CLLocationManager()
    var restaurants: [Restaurant] = []
    var locationIterations = 0
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        locationManager.startUpdatingLocation()
        activityIndicator.startAnimating()
        
        // get location &
        // stop animating and hide
        // both done in getNearby()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.hidesWhenStopped = true
        
        // Start doing location stuff
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.delegate = self
      //  locationManager.startUpdatingLocation()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func getNearby(lat: Double, lng: Double) {
        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(String(describing: lat)),\(String(describing: lng))&type=restaurant&rankby=distance&key=\(String(describing: kPlacesWebAPIKey))"
        // Clear restaurants
        restaurants = []
        Alamofire.request(url, method:.get, parameters:nil).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                var json = JSON(value)
                if let error_message: String = json["error_message"].string {
                    print(error_message)
                } else {
                    var i = 0
                    for obj in json["results"] {
                        Restaurant.getRestaurantInfo(google_link: obj.1["place_id"].string!, completion: { (restaurant: Restaurant) in
                            self.restaurants.append(restaurant)
                            if(i == 0) {
                                self.restaurantLabel.text = restaurant.name
                                self.activityIndicator.stopAnimating()
                            }
                            i += 1
                        })
                    }
                }
            case .failure(let error):
                print(error)
                print("There was an error")
            }
        }
    }
}

extension CheckinViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        getNearby(lat: locations[0].coordinate.latitude, lng: locations[0].coordinate.longitude)
        locationManager.stopUpdatingLocation()
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
}
