//
//  Favorite.swift
//  Weat
//
//  Created by ctydw on 3/11/18.
//  Copyright © 2018 Weat. All rights reserved.
//
import FBSDKCoreKit
import Alamofire
import SwiftyJSON
import Foundation
class Favorite{
    
    /* TESTED, see example of using this function in /WeatTests "testPostFavorite()" function
     * Set a restaurant to be the user's favorite
     * This function requires the google_link of the restaurant the user wants to set as favorite
     * The returned result is a boolean variable that indicated whether the favorite has created successfully or not
     * Access token is automatically obtained
     */
    static func addFavoriteRestaurant(google_link: String, restaurant_name: String, completion: @escaping(Bool)->()){
        let url = "\(String(WeatAPIUrl))/favorites"
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
            "google_link": google_link,
            "restaurant_name": restaurant_name
        ]
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        var status = false
        Alamofire.request(url, method:.post, parameters: params, encoding:URLEncoding.httpBody, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                status = true
                print(json)
            case .failure(let error):
                print(error)
            }
            completion(status)
        }
    }
    
    /* TESTED, see example of using this function in /WeatTests "testDeleteFavorite()" function
     * Delete a restaurant from the user's favorite restaurant list
     * This function requires the google link of the restaurant the user wants to delete
     * The returned value is a boolean variable that indicates whether the favorite is deleted or not
     */
    static func deleteFavoriteRestaurant(google_link: String, completion: @escaping(Bool)->()){
        let url = "\(String(WeatAPIUrl))/favorites"
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
            "google_link": google_link
        ]
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        var status = false
        Alamofire.request(url, method:.delete, parameters: params, encoding:URLEncoding.httpBody, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                status = true
                print(json)
            case .failure(let error):
                print(error)
            }
            completion(status)
        }
    }
}
