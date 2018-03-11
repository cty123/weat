//
//  Restaurant.swift
//  Weat
//
//  Created by Sean Becker on 2/22/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import GooglePlaces
class Restaurant {
    var latitude: Double?
    var longitude: Double?
    var name: String?
    var image: UIImage?
    var google_id: String?
    var phone: String?
    
    static func getRestaurantInfo(json: JSON, retrieveImage: Bool, completion: @escaping (Restaurant) -> ()){
        // TODO: Check if google returns bad json
        let restaurant = Restaurant()
        let jsonArr:[JSON] = json["photos"].array! // add error check
        let photo_reference:String = jsonArr[0]["photo_reference"].string!
        let photo_url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(String(photo_reference))&key=\(String(kPlacesWebAPIKey))"
        restaurant.google_id = json["place_id"].string!
        restaurant.latitude = json["geometry"]["location"]["lat"].double!
        restaurant.longitude = json["geometry"]["location"]["lng"].double!
        restaurant.name = json["name"].string!
        if(retrieveImage) {
            Alamofire.request(photo_url, method:.get, parameters:nil).validate().responseData(completionHandler: {
                (response) in
                if(response.error == nil) {
                    if let data = response.data {
                        restaurant.image = UIImage(data: data)
                    } else {
                        restaurant.image = UIImage(named: "Explore")
                    }
                } else {
                    print(response.error ?? "Couldn't get restaurant info from Google (Restaurant.swift)")
                }
                completion(restaurant)
            })
        } else {
            completion(restaurant)
        }
    }
    
    static func getDetails(oldRestaurant: Restaurant, completion: @escaping (Restaurant) -> ()) {
        let restaurant = Restaurant()
        restaurant.google_id = oldRestaurant.google_id
        restaurant.image = oldRestaurant.image
        restaurant.latitude = oldRestaurant.latitude
        restaurant.longitude = oldRestaurant.longitude
        restaurant.name = oldRestaurant.name
        let info_url = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(String(describing: restaurant.google_id))&key=\(kPlacesWebAPIKey)"
        Alamofire.request(info_url, method:.get, parameters:nil).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                var json = JSON(value)
                if let error_message: String = json["error_message"].string {
                    print(error_message)
                } else {
                    restaurant.phone = json["formatted_phone_number"].string
                    // add more details here as needed
                }
            case .failure(let error):
                print(error)
                print("There was an error")
            }
            completion(restaurant)
        }
    }
}
