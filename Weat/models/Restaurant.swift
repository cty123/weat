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
import FBSDKLoginKit

class Restaurant {
    var latitude: Double?
    var longitude: Double?
    var price: String?
    var name: String?
    var image: UIImage?
    var google_link: String?
    var phone: String?
    var open_now: String?
    var is_favorite: Bool?
    
    //Rating is initialized to be 0
    var rating = (food_good_all: 0, food_bad_all:0, food_count_all: 0,
                  service_good_all: 0, service_bad_all:0, service_count_all: 0,
                  food_good_friends: 0, food_bad_friends:0, food_count_friends: 0,
                  service_good_friends: 0, service_bad_friends:0, service_count_friends: 0, ratings_exist: false)
    
    /* Restaurant rating is composed of 2 parts, 1. Comments from friends.
     * 2. Ratings datas like food_good_all, food_good_friend, from condensed_rating form
     *
     */
    var comments = [Comment]()
    var menu = [Menu_item]()
    
    /* Get google restaurant info */
    static func getRestaurantInfo(google_link: String, completion: @escaping (Restaurant) -> ()){
        let restaurant = Restaurant()
        restaurant.google_link = google_link
        var photo_url: String = ""
        
        // use google link to get details
        let info_url = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(String(describing: google_link))&key=\(kPlacesWebAPIKey)"
        Alamofire.request(info_url, method:.get, parameters:nil).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                var json = JSON(value)
                if let error_message: String = json["error_message"].string {
                    print("restaurant model error: " + error_message)
                } else {
                    let latitude = json["result"]["geometry"]["location"]["lat"].double
                    let longitude = json["result"]["geometry"]["location"]["lng"].double
                    let name = json["result"]["name"].string
                    let phone = json["result"]["formatted_phone_number"].string
                    
                    restaurant.latitude = (latitude != nil ? latitude : 0.0)!
                    restaurant.longitude = (longitude != nil ? longitude : 0.0)!
                    restaurant.name = (name != nil ? name : "No name...")!
                    restaurant.phone = (phone != nil ? phone : "No phone...")!
                    switch json["result"]["open_now"].bool {
                    case true?:
                        restaurant.open_now = "Open"
                    default:
                        restaurant.open_now = "Closed"
                    }
                    // add more details here as needed
                    switch json["result"]["price_level"].int {
                    case 0?:
                        restaurant.price = "Free"
                    case 1?:
                        restaurant.price = "Inexpensive"
                    case 2?:
                        restaurant.price = "Moderate"
                    case 3?:
                        restaurant.price = "Expensive"
                    case 4?:
                        restaurant.price = "Very Expensive"
                    default:
                        restaurant.price = "Moderate"
                    }
                    // use details to get photo
                    if(json["result"]["photos"].array != nil) {
                        let jsonArr:[JSON] = json["result"]["photos"].array!
                        let photo_reference:String = jsonArr[0]["photo_reference"].string!
                        photo_url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(String(photo_reference))&key=\(String(kPlacesWebAPIKey))"
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
            case .failure(let error):
                print(error)
                print("There was an error")
                completion(restaurant)
            }
        }
    }
    
    /* TESTED Finished
     * Get menu for a restaurant along with the ratings, the ratings contains the (name of) author
     * The result is a array of Menu_item with ratings(might be null if no one has a rating for this item)
     * The ratings are from the user's friends ONLY
     * Access token is automatically obtained
     */
    func getRestaurantMenuWithRating(completion: @escaping (Bool)->()){
        let url = "\(String(WeatAPIUrl))/restaurants/menu"
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
            "google_link": self.google_link!,
            "restaurant_name": self.name!
        ]
        Alamofire.request(url, method:.get, parameters:params).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let message = json["message"].stringValue
                // Debug option
                print(json)
                if (message == "OK"){
                    self.name = json["restaurant"]["name"].stringValue;
                    for menu_item in json["restaurant"]["menu_items"].arrayValue{
                        let category = menu_item["category"]
                        let item = Menu_item()
                        item.id = menu_item["id"].intValue
                        item.category = category.stringValue
                        item.name = menu_item["name"].stringValue
                        // Will implement rating later
                        for rating in menu_item["ratings"].arrayValue{
                            let r = Rating()
                            r.author = rating["user"]["name"].stringValue
                            r.author_FB_link = rating["user"]["facebook_link"].stringValue
                            r.authorID = rating["user_id"].intValue
                            r.food_rating = rating["food_rating"].intValue
                            r.id = rating["id"].intValue
                            r.rating_text = rating["rating_text"].stringValue
                            r.restaurant_id = json["restaurant"]["id"].intValue
                            r.menu_item_id = rating["menu_item_id"].intValue
                            r.service_rating = nil
                            // Format the date string
                            let str = rating["createdAt"].stringValue
                            let trimmedIsoString = str.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
                            r.time = ISO8601DateFormatter().date(from: trimmedIsoString)
                            item.rating.append(r)
                        }
                        self.menu.append(item)
                    }
                    completion(true)
                }else{
                    completion(false)
                }
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    /*
     * Pull rating for an existing restaurant object, this function is for ratings ONLY
     * The result is a array of Rating
     * Parameter: google_link, String
     * Access token is automatically obtained from local statics
     */
    func getRestaurantRating(completion: @escaping (Bool)->()){
        let url = "\(String(WeatAPIUrl))/rating"
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
            "google_link": self.google_link!,
            "restaurant_name": self.name!
        ]
        Alamofire.request(url, method:.get, parameters:params).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let message = json["message"].stringValue
                // Debug option
                print(json)
                if message == "OK" {
                    // Start to parse json
                    self.rating.ratings_exist = json["ratings_exist"].boolValue
                    self.rating.food_good_all = json["data"]["food_good_all"].intValue
                    self.rating.food_bad_all = json["data"]["food_bad_all"].intValue
                    self.rating.food_count_all = json["data"]["food_count_all"].intValue
                    self.rating.service_good_all = json["data"]["service_good_all"].intValue
                    self.rating.service_bad_all = json["data"]["service_bad_all"].intValue
                    self.rating.service_count_all = json["data"]["service_count_all"].intValue
                    self.rating.food_good_friends = json["data"]["food_good_friends"].intValue
                    self.rating.food_bad_friends = json["data"]["food_bad_friends"].intValue
                    self.rating.food_count_friends = json["data"]["food_count_friends"].intValue
                    self.rating.service_good_friends = json["data"]["service_good_friends"].intValue
                    self.rating.service_bad_friends = json["data"]["service_bad_friends"].intValue
                    self.rating.service_count_friends = json["data"]["service_count_friends"].intValue
                    completion(true)
                }else{
                    completion(false)
                }
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    /* TESTED Finished
     * Get comments for the restaurant
     * The restaurant has an array of comments, (For now) those comments are from friends ONLY
     * This function returns a boolean variable that indicated the status of this function true = success, false = failed
     * The updated comments will be stored at restaurant.comments
     */
    func getRestaurantComments(completion:@escaping(Bool)->()){
        let url = "\(String(WeatAPIUrl))/restaurants/comments"
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
            "google_link": self.google_link!,
            "restaurant_name": self.name!
        ]
        Alamofire.request(url, method:.get, parameters:params).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let messge = json["message"].stringValue
                // Debug option
                print(json)
                if messge == "OK" {
                    for r in json["comments"].arrayValue{
                        let comment = Comment()
                        comment.id = r["id"].intValue
                        comment.author_FB_link = r["user"]["facebook_link"].stringValue
                        comment.authorID = r["user_id"].intValue
                        comment.restaurant_id = r["restaurant_id"].intValue
                        comment.food_rating = r["food_rating"].intValue
                        comment.service_rating = r["service_rating"].intValue
                        comment.comment_text = r["rating_text"].stringValue
                        // Format the date string
                        let str = r["createdAt"].stringValue
                        let trimmedIsoString = str.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
                        comment.time = ISO8601DateFormatter().date(from: trimmedIsoString)
                        // This is null because this is a rating for a restaurant not for a menu item
                        comment.author = r["user"]["name"].stringValue
                        self.comments.append(comment)
                    }
                    completion(true)
                }else{
                    completion(false)
                }
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    /* Tested
    * This function is used to obtain the COMPLETE details of a restaurant, including menu, menu item rating and restaurant ratings
    * This function is a integration of all restaurant functions EXCEPT FOR pull condensed rating, you need to call updateRating separately
    */
    func getRestaurant(completion: @escaping (Bool)->()){
        let url = "\(String(WeatAPIUrl))/restaurants/detail"
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
            "google_link": self.google_link!,
            "restaurant_name": self.name!
        ]
        Alamofire.request(url, method:.get, parameters:params).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                // Debug option
                print("getRestaurant json:")
                print(json)
                // Status message -- Will add a status module that determines if the request has succeeded
                let message = json["message"].stringValue
                if message == "OK" {
                    // Start parsing json --- updating menu
                    self.name = json["restaurant"]["name"].string
                    self.is_favorite = json["is_favorite"].bool
                    for menu_item in json["restaurant"]["menu_items"].arrayValue{
                        let item = Menu_item()
                        item.id = menu_item["id"].intValue
                        item.category = menu_item["category"].stringValue
                        item.name = menu_item["name"].stringValue
                        // Loop through ratings for menu items to fill the menu for the restaurant
                        for rating in menu_item["ratings"].arrayValue{
                            // Load ratings
                            let r = Rating()
                            r.author = rating["user"]["name"].stringValue
                            r.author_FB_link = rating["user"]["facebook_link"].stringValue
                            r.authorID = rating["user_id"].intValue
                            r.food_rating = rating["food_rating"].intValue
                            r.id = rating["id"].intValue
                            r.rating_text = rating["rating_text"].stringValue
                            r.restaurant_id = json["restaurant"]["id"].intValue
                            r.menu_item_id = json["menu_item_id"].intValue
                            r.service_rating = nil
                            // Format the date string
                            let str = rating["createdAt"].stringValue
                            let trimmedIsoString = str.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
                            r.time = ISO8601DateFormatter().date(from: trimmedIsoString)
                            // Add this rating to menu item
                            item.rating.append(r)
                        }
                        self.menu.append(item)
                    }
                    // Purge old comments
                    self.comments.removeAll()
                    // Loop through the restaurant ratings --- Updating ratings
                    for r in json["comments"].arrayValue{
                        let comment = Comment()
                        comment.id = r["id"].intValue
                        comment.author_FB_link = r["user"]["facebook_link"].stringValue
                        comment.restaurant_id = r["restaurant_id"].intValue
                        comment.food_rating = r["food_rating"].intValue
                        comment.service_rating = r["service_rating"].intValue
                        comment.comment_text = r["rating_text"].stringValue
                        // Format the date string
                        let str = r["createdAt"].stringValue
                        let trimmedIsoString = str.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
                        comment.time = ISO8601DateFormatter().date(from: trimmedIsoString)
                        // This is null because this is a rating for a restaurant not for a menu item
                        comment.author = r["user"]["name"].stringValue
                        comment.authorID = r["user_id"].intValue
                        self.comments.append(comment)
                    }
                    completion(true)
                }else{
                    completion(false)
                }
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    func testGetRestaurant(){
        //let sem = dispatch_semaphore_create(1)
        
    }
}
