import Foundation
import Alamofire
import SwiftyJSON
import FBSDKCoreKit

class User{
    var id: Int?
    var name: String?
    var email: String?
    var phone: String?
    var location: String?
    var privacy: Int?
    var favorites = [Restaurant]()
    var recommendations = [Recommendation]()
    
    // Get User info
    static func getUserInfo(profile_id:String, completion: @escaping (User) -> ()){
        let url = "\(String(WeatAPIUrl))/user/profile"
        let params = [
            "access_token" : FBSDKAccessToken.current().tokenString!,
            "profile_id" : profile_id
        ]
        let user = User()
        Alamofire.request(url, method:.get, parameters:params).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                user.name = json["user"]["name"].string
                user.location = json["user"]["location"].string
                user.email = json["user"]["email"].string
                user.id = json["user"]["id"].int
                user.privacy = json["user"]["privacy"].int
                user.phone = json["user"]["phone"].string
                // Get favorite
                for favorite in json["favorites"].arrayValue{
                    let r = Restaurant()
                    r.google_link = favorite["restaurant"]["google_link"].stringValue
                    r.name = favorite["restaurant"]["name"].stringValue
                    user.favorites.append(r)
                }
                
                // Get recommendation
                for r in json["recommendations"].arrayValue{
                    let recommendation = Recommendation()
                    recommendation.friend_id = r["friend"]["id"].intValue
                    recommendation.friend_name = r["friend"]["name"].stringValue
                    recommendation.restaurant_id = r["restaurant_id"].intValue
                    recommendation.restaurant_name = r["restaurant"]["name"].stringValue
                    recommendation.recommended_menu_item_id = r["menu_item"]["id"].intValue
                    recommendation.recommended_menu_item_name = r["menu_item"]["name"].stringValue
                    // Format the date string
                    let str = r["createdAt"].stringValue
                    let trimmedIsoString = str.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
                    recommendation.time = ISO8601DateFormatter().date(from: trimmedIsoString)
                    user.recommendations.append(recommendation)
                }
            case .failure(let error):
                print(error)
            }
            completion(user)
        }
    }
    
    // Change user profile
    /*
     * Will rewrite to make this function static
     */
    func updateUserInfo(completion: @escaping (Bool) -> ()){
        let url = "\(String(WeatAPIUrl))/user/profile"
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
            "id" : self.id.map(String.init)!,
            "name": self.name!,
            "email" : self.email!,
            "phone": self.phone!,
            "location": self.location!,
            "privacy": self.privacy.map(String.init)!
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
    
    /*
     * Will rewrite to make this function static
     */
    //Delete User account from the database   ----- not tested
    func deleteUser(completion: @escaping (Bool) -> ()){
        let url = "\(String(WeatAPIUrl))/user"
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let params = [
            "access_token": "test"//FBSDKAccessToken.current().tokenString!
        ]
        var status = false
        Alamofire.request(url, method:.delete, parameters: params, encoding:URLEncoding.httpBody, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(_):
                status = true
            case .failure(let error):
                status = false
                print(error)
            }
            completion(status)
        }
    }

}

