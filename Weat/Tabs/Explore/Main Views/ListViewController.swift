import UIKit
import GooglePlaces
import Alamofire
import SwiftyJSON

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var locationManager = CLLocationManager()
    var defaultLocation: CLLocation?
    var restaurants: [Restaurant] = []
    
    // The currently selected place.
    var selectedPlace: GMSPlace?
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        
        getNearby(lat: exploreLocations.latitude!, lng: exploreLocations.longitude!)
        
        // table view init
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Set location
    }
    
    func getNearby(lat: Double, lng: Double) {
        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(String(describing: lat)),\(String(describing: lng))&radius=8000&type=restaurant&key=\(String(describing: kPlacesWebAPIKey))"
        // Clear restaurants
        restaurants = []
        Alamofire.request(url, method:.get, parameters:nil).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                var json = JSON(value)
                if let error_message: String = json["error_message"].string {
                    print(error_message)
                } else {
                    for obj in json["results"] {
                        Restaurant.getRestaurantInfo(google_link: obj.1["place_id"].string!, completion: { (restaurant: Restaurant) in
                            self.restaurants.append(restaurant)
                            self.tableView.reloadData()
                        })
                    }
                    // Google Places only allows 20 results per query, but includes a 'next page' token if there are more results (up to 60 results, so 3 pages)
                    // Below allows you to get more results.
                    // TODO: make this code less ugly
                        /*if let next_page_token = json["next_page_token"].string {
                            url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(String(describing: lat)),\(String(describing: lng))&radius=8000&type=restaurant&key=\(String(describing: kPlacesWebAPIKey))&pagetoken=\(next_page_token)"
                            Alamofire.request(url, method:.get, parameters:nil).validate().responseJSON { response in
                                switch response.result {
                                case .success(let value):
                                    print(json)
                                    json = JSON(value)
                                    if let error_message: String = json["error_message"].string {
                                        print(error_message)
                                    } else {
                                        for obj in json["results"] {
                                            Restaurant.getRestaurantInfo(json: obj.1, retrieveImage: true, completion: { (restaurant: Restaurant) in
                                                self.restaurants.append(restaurant)
                                                self.tableView.reloadData()
                                                print(self.restaurants.count)
                                            })
                                        }
                                    }
                                case .failure(let error):
                                    print(error)
                                    print("There was an error")
                                }
                            }
                        }*/
                }
            case .failure(let error):
                print(error)
                print("There was an error")
            }
        }
    }
    
    // tableview stuff
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // feed = 0
        let count: Int = restaurants.count
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 44 is the standard height of a row
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("RestaurantTableViewCell", owner: self, options: nil)?.first as! RestaurantTableViewCell
            
        let list_obj = restaurants[indexPath.row]
        
        cell.labelName.text = "\(String(describing: list_obj.name!))"
        cell.imageViewPic.image = list_obj.image!
        cell.labelDetail.text = "Rating holder"
        cell.restaurant = list_obj
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // keeps a row from being permenantly selected
        tableView.deselectRow(at: indexPath, animated: true)
        
        // get restaurant details at index path clicked
        let cell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
        let restaurantViewController = RestaurantViewController(nibName: "RestaurantViewController", bundle: nil)
        restaurantViewController.restaurant = cell.restaurant
        restaurantViewController.back_string = "List"
        restaurantViewController.viewWillAppear(true)
        self.present(restaurantViewController, animated: true, completion: nil)
    }
}

extension ListViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defaultLocation = locations.last!
        getNearby(lat: locations[0].coordinate.latitude, lng: locations[0].coordinate.longitude)
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
extension ListViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        locationManager.stopUpdatingLocation()
        exploreLocations.latitude = place.coordinate.latitude
        exploreLocations.longitude = place.coordinate.longitude
        var isRestaurant: Bool = false
        let types = place.types
        for type in types {
            if(type == "restaurant") {
                isRestaurant = true
                break
            }
        }
        if(isRestaurant) {
            let restaurantViewController = RestaurantViewController(nibName: "RestaurantViewController", bundle: nil)
            Restaurant.getRestaurantInfo(google_link: place.placeID, completion: { (restaurant: Restaurant) in
                restaurantViewController.restaurant = restaurant
                restaurantViewController.back_string = "List"
                self.present(restaurantViewController, animated: true, completion: nil)
            })
        } else {
            getNearby(lat: exploreLocations.latitude!, lng: exploreLocations.longitude!)
        }
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
