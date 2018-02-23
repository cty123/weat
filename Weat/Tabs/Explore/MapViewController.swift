//
//  MapViewController.swift
//  Weat
//
//  Created by Sean Becker on 2/21/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker
import GoogleMaps
import Alamofire
import SwiftyJSON

class MapViewController: UIViewController, UISearchBarDelegate {
    var locationManager = CLLocationManager()
    var defaultLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 12.0
    var searchActive : Bool = false
    
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    
    // The currently selected place.
    var selectedPlace: GMSPlace?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        
        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        if(defaultLocation == nil) {
            defaultLocation = CLLocation.init(latitude: 0, longitude: 0)
        }
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation!.coordinate.latitude,
                                              longitude: defaultLocation!.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        // Add the map to the view, hide it until we've got a location update.
        view.insertSubview(mapView, at: 0)
        mapView.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        dropPins(lat: locations[0].coordinate.latitude, lng: locations[0].coordinate.longitude)
        //listLikelyPlaces()
    }
    
    func dropPins(lat: Double, lng: Double) {
        let api_key = "AIzaSyBwesCsXhnK5qdbaSkjrKDOlGHgYGhDMdg"
        var restaurants: [Restaurant] = []
        
        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(String(describing: lat)),\(String(describing: lng))&radius=8000&type=restaurant&key=\(String(describing: api_key))"
        
        Alamofire.request(url, method:.get, parameters:nil).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for obj in json["results"] {
                    let restaurant = Restaurant(json: obj.1)
                    restaurants.append(restaurant)
                }
                for obj in restaurants {
                    let position = CLLocationCoordinate2D(latitude: obj.latitude, longitude: obj.longitude)
                    let marker = GMSMarker(position: position)
                    marker.title = obj.name
                    marker.map = self.mapView
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
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
