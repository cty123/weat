// implement rating function
// Post a rating
import Foundation
import FBSDKCoreKit
import Alamofire
import SwiftyJSON

class Rate{
    
    // Post a new rating
    static func postRating(restaurant_id:String, rating:String, rating_text:String, completion:@escaping(Bool)->()){
        let url = "\(String(WeatAPIUrl))/rating"
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
            "restaurant_id": restaurant_id,
            "rating": rating,
            "rating_text": rating_text
        ]
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        var status = false;
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
    
    // Pull ratings from server --------- not finished
//    static func getRatings(restaurant_id:String){
//        let url = "\(String(describing: WeatAPIUrl))/rating/details"
//        let params = [
//            "access_token": FBSDKAccessToken.current().tokenString!,
//            "restaurant_id": restaurant_id
//        ]
//
//    }
    
    
}

//get detail
//let access_token = req.query.access_token;
//let restaurant_id = req.query.restaurant_id;

//get ratings
//let access_token = req.query.access_token;
//let restaurant_id = req.query.restaurant_id;
