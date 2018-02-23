import UIKit
import GooglePlacePicker
import Alamofire
import SwiftyJSON

class ListViewController: UIViewController {
    
    var locationManager = CLLocationManager()
    var defaultLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        
        
        /*placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                for likelihood in placeLikelihoodList.likelihoods {
                    let place = likelihood.place
                    print("Current Place name \(place.name) at likelihood \(likelihood.likelihood)")
                    print("Current Place address \(String(describing: place.formattedAddress))")
                    print("Current Place attributions \(String(describing: place.attributions))")
                    print("Current PlaceID \(place.placeID)")
                }
            }
        })*/
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Set location
    }
    
    func sendApiCall() {
        if(defaultLocation == nil) {
            return
        }
        let lat = defaultLocation!.coordinate.latitude
        let long = defaultLocation!.coordinate.longitude
        let api_key = "AIzaSyBwesCsXhnK5qdbaSkjrKDOlGHgYGhDMdg"
        
        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(String(describing: lat)),\(String(describing: long))&radius=8000&type=restaurant&key=\(String(describing: api_key))"
        //print(url)
        
        Alamofire.request(url, method:.get, parameters:nil).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ListViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defaultLocation = locations.last!
        sendApiCall()
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
