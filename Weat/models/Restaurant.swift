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
class Restaurant {
    var latitude: Double?
    var longitude: Double?
    var name: String?
    var image: UIImage?
    
    static func getRestaurantInfo(json: JSON, retrieveImage: Bool, completion: @escaping (Restaurant) -> ()){
        // TODO: Check if google returns bad json
        
        let restaurant = Restaurant()
        let jsonArr:[JSON] = json["photos"].array! // add error check
        let photo_reference:String = jsonArr[0]["photo_reference"].string!
        let url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(String(photo_reference))&key=\(String(kPlacesWebAPIKey))"
        restaurant.latitude = json["geometry"]["location"]["lat"].double!
        restaurant.longitude = json["geometry"]["location"]["lng"].double!
        restaurant.name = json["name"].string!
        if(retrieveImage) {
            Alamofire.request(url, method:.get, parameters:nil).validate().responseData(completionHandler: {
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
}
