//
//  Recommendation.swift
//  Weat
//
//  Created by ctydw on 3/18/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import Alamofire
import SwiftyJSON
class Recommendation{
    var friend_id: Int?
    var friend_name: String?
    var restaurant_id: Int?
    var restaurant_name: String?
    var recommended_menu_item_name: String?
    var recommended_menu_item_id: Int?
    var time: Date?
    var google_link: String?
    
    /*
    * This function is used to send recommendations to friends
     * NOTE: friend_ids can be multiple friend ids separated by ',' like 1,3,4,5.
    */
    static func sendRecommendation(google_link:String, menu_item_id: Int, restaurant_name:String, friend_ids:String, completion:@escaping(Bool)->()){
        let url = "\(String(WeatAPIUrl))/recommendation"
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
            "google_link": google_link,
            "menu_item_id": String(menu_item_id),
            "restaurant_name": restaurant_name,
            "friend_ids": friend_ids
        ]
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        Alamofire.request(url, method:.post, parameters: params, encoding:URLEncoding.httpBody, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let message = json["message"]
                if message == "Recommendations sent" {
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
}
