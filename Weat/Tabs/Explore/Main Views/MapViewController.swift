//
//  MapViewController.swift
//  Weat
//
//  Created by Sean Becker on 2/21/18.
//  Copyright © 2018 Weat. All rights reserved.
//

// TODO: Discuss what happens when restaurant is clicked in autocomplete (either stay on map view or go to restaurant view)

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
    var restaurants: [Restaurant] = []
    
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    
    // The currently selected place.
    var selectedPlace: GMSPlace?
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Google Maps autocomplete result controller
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        // Initialize search controller for google autocomplete
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchController?.hidesNavigationBarDuringPresentation = false
        
        // Initialize search bar
        let searchBar = searchController?.searchBar
        searchBar?.sizeToFit()
        searchBar?.backgroundImage = UIImage.imageWithColor(color: UIColor(red: 1, green: 0.5871, blue: 0, alpha: 1.0), size: CGSize(width: (searchBar?.frame.width)!,height: (searchBar?.frame.height)!))
        
        // Initialize subview for search bar
        let subView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 45.0))
        
        // Add searchbar to view
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Get rid of shadow under navbar
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // Start doing location stuff
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.delegate = self
        
        // If we don't have a location yet, we want to start updating the location as soon as possible
        if(exploreLocations.latitude == nil || exploreLocations.longitude == nil) {
            locationManager.startUpdatingLocation()
        }
        placesClient = GMSPlacesClient.shared()
        
        // Placeholder for default location
        if(defaultLocation == nil) {
            defaultLocation = CLLocation.init(latitude: 0, longitude: 0)
        }
        
        // Move to location on map
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation!.coordinate.latitude,
                                              longitude: defaultLocation!.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        // Add the map to the view. If we haven't set a location yet, hide it until we've got a location.
        // Otherwise, move to the given location
        view.insertSubview(mapView, at: 0)
        if(exploreLocations.latitude == nil || exploreLocations.longitude == nil) {
            mapView.isHidden = true
        } else {
            moveTo(latitude: exploreLocations.latitude!, longitude: exploreLocations.longitude!)
            mapView.isHidden = false
        }
        
        
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
    
    func moveTo(latitude: Double, longitude: Double) {
        let camera = GMSCameraPosition.camera(withLatitude: latitude,
                                              longitude: longitude,
                                              zoom: zoomLevel)
        mapView.clear()
        mapView.animate(to: camera)
        dropPins(lat: latitude, lng: longitude)
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
        exploreLocations.latitude = locations[0].coordinate.latitude
        exploreLocations.longitude = locations[0].coordinate.longitude
    }
    
    func dropPins(lat: Double, lng: Double) {
        
        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(String(describing: lat)),\(String(describing: lng))&radius=8000&type=restaurant&key=\(String(describing: kPlacesWebAPIKey))"
        
        Alamofire.request(url, method:.get, parameters:nil).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for obj in json["results"] {
                    Restaurant.getRestaurantInfo(google_link: obj.1["place_id"].string!, completion: { (restaurant: Restaurant) in
                        self.restaurants.append(restaurant)
                        let position = CLLocationCoordinate2D(latitude: restaurant.latitude!, longitude: restaurant.longitude!)
                        let marker = GMSMarker(position: position)
                        marker.title = restaurant.name
                        marker.map = self.mapView
                    })
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

// Handle the user's selection.
extension MapViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        locationManager.stopUpdatingLocation()
        moveTo(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        exploreLocations.latitude = place.coordinate.latitude
        exploreLocations.longitude = place.coordinate.longitude
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension UIImage {
    
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

extension MapViewController: GMSMapViewDelegate {
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        locationManager.startUpdatingLocation()
        return false
    }
}
