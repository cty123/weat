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
import FBSDKCoreKit

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
    
    /*
     * Get menu for a restaurant, this function is for menu ONLY, for menu with friends ratings/comments, use "getRestaurantMenuWithRating()"
     * The result is a array of Menu_item
     * Parameter: google_link, String
     * Access token is automatically obtained from local statics
     */
    static func getRestaurantMenu(google_link: String,completion: @escaping (([Menu_item]))->()){
        let url = "\(String(WeatAPIUrl))/restaurants/menu"
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
            "google_link": google_link
        ]
        var menu_items = [Menu_item]()
        Alamofire.request(url, method:.get, parameters:params).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                // Debug option
                print(json)
                for menu_item in json["menu_items"].arrayValue{
                    let category = menu_item["name"]
                    for i in menu_item["items"].arrayValue{
                        let item = Menu_item()
                        item.id = i["id"].intValue
                        item.category = category.stringValue
                        item.name = i["name"].stringValue
                        // Will implement rating later
                        item.rating = nil
                        menu_items.append(item)
                    }
                }
            case .failure(let error):
                print(error)
            }
            completion(menu_items)
        }
    }
    
    /*
     * Get rating for a restaurant, this function is for ratings ONLY
     * The result is a array of Rating
     * Parameter: google_link, String
     * Access token is automatically obtained from local statics
     */
    static func getRestaurantRating(google_link: String,completion: @escaping (([Rating]))->()){
        let url = "\(String(WeatAPIUrl))/restaurants/comments"
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
            "google_link": google_link
        ]
        var ratings = [Rating]()
        Alamofire.request(url, method:.get, parameters:params).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                // Debug option
                print(json)
                for r in json["restaurant"]["ratings"].arrayValue{
                    let rating = Rating()
                    rating.id = r["id"].intValue
                    rating.restaurant_id = r["restaurant_id"].intValue
                    rating.food_rating = r["food_rating"].intValue
                    rating.service_rating = r["service_rating"].intValue
                    rating.rating_text = r["rating_text"].stringValue
                    let str = r["createdAt"].stringValue
                    let trimmedIsoString = str.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
                    rating.time = ISO8601DateFormatter().date(from: trimmedIsoString)
                    // This is null because this is a rating for a restaurant not for a menu item
                    rating.menu_item_id = nil
                    // Null for now will implement later
                    rating.author = nil
                    ratings.append(rating)
                }
            case .failure(let error):
                print(error)
            }
            completion(ratings)
        }
    }
}
