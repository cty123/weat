//
//  Rating.swift
//  Weat
//
//  Created by ctydw on 3/10/18.
//  Copyright © 2018 Weat. All rights reserved.
//
import Alamofire
import FBSDKCoreKit
import SwiftyJSON
import Foundation
class Rating {
    /*
     * This class stores ratings for both menu items and restaurants
     */
    var id: Int?
    // The writer/author of this rating
    var author: String?
    
    var restaurant_id: Int?
    var food_rating: Int?
    var service_rating: Int?
    var rating_text: String?
    var menu_item_id: Int?
    var time: Date?
    
    /*
     * This function is not finished, will be implemented when the backend is modified
     * Post restaurant rating
     * Requires: google_link, restaurant_name, food_rating, service_rating, rating_text
     * Returns a boolean variable that indicates if it has successfully posted
     */
    static func postRestaurantRating(google_link: String, restaurant_name: String, food_rating:Int, service_rating:Int, rating_text:String, completion: @escaping(Bool)->()){
        let url = "\(String(WeatAPIUrl))/rating"
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
            "google_link": google_link,
            "restaurant_name": restaurant_name,
            "food_rating": String(food_rating),
            "service_rating": String(service_rating),
            "rating_text": rating_text,
        ]
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        Alamofire.request(url, method:.post, parameters: params, encoding:URLEncoding.httpBody, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let message = json["message"].stringValue
                if message == "Rating updated"{
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
     * This function is not finished, will be implemented when the backend is modified
     * Post restaurant rating
     * Requires: google_link, restaurant_name, menu_item_id, food_rating, rating_text
     * Returns a boolean variable that indicates if it has successfully posted
     */
    static func postMenuItemRating(google_link: String, restaurant_name: String, menu_item_id: Int, food_rating: Int, rating_text:String, completion:@escaping(Bool)->()){
        let url = "\(String(WeatAPIUrl))/rating"
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
            "google_link": google_link,
            "restaurant_name": restaurant_name,
            "menu_item_id": String(menu_item_id),
            "food_rating": String(food_rating),
            "rating_text": rating_text,
            ]
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        Alamofire.request(url, method:.post, parameters: params, encoding:URLEncoding.httpBody, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let message = json["message"].stringValue
                if message == "Rating updated"{
                    completion(true)
                }else{
                    completion(false)
                }
                print(json)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
}
