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
    var facebook_link: String?
    
    // Get User info
    static func getUserInfo(profile_id:String, completion: @escaping ((Result<User>) -> ())){
        let url = "\(String(WeatAPIUrl))/user/profile"
        let params = [
            "access_token" : FBSDKAccessToken.current().tokenString!,
            "profile_id" : profile_id
        ]
        let user = User()
        Alamofire.request(url, method:.get, parameters:params).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                // Obtain JSON package
                let json = JSON(value)
                let message = json["message"].stringValue
                // Check status based on the return message
                switch message{
                    case "OK":
                        // Parse json package
                        user.name = json["user"]["name"].stringValue
                        user.location = json["user"]["location"].stringValue
                        user.email = json["user"]["email"].stringValue
                        user.id = json["user"]["id"].intValue
                        user.privacy = json["user"]["privacy"].intValue
                        user.phone = json["user"]["phone"].stringValue
                        user.facebook_link = json["user"]["facebook_link"].stringValue
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
                            recommendation.google_link = r["restaurant"]["google_link"].stringValue
                            // Format the date string
                            let str = r["createdAt"].stringValue
                            let trimmedIsoString = str.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
                            recommendation.time = ISO8601DateFormatter().date(from: trimmedIsoString)
                            user.recommendations.append(recommendation)
                        }
                        completion(.success(user))
                case "No profile id given":
                    completion(.failure(RequestError.noProfileId(msg:message)))
                case "No access token given":
                    completion(.failure(RequestError.noAccessToken(msg:message)))
                case "Not allowed":
                    completion(.failure(RequestError.notAllowed(msg:message)))
                case "No authentication":
                    completion(.failure(RequestError.noAuthentication(msg:message)))
                default:
                    completion(.failure(AFError.invalidURL(url: url)))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    // Change user profile
    /*
     * Will rewrite to make this function static
     */
    func updateUserInfo(completion: @escaping (Result<Bool>) -> ()){
        let url = "\(String(WeatAPIUrl))/user/profile"
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
            "id" : String(describing:self.id),
            "name": self.name!,
            "email" : self.email!,
            "phone": self.phone!,
            "location": self.location!,
            "privacy": String(describing:self.privacy)
        ]
        Alamofire.request(url, method:.post, parameters: params, encoding:URLEncoding.httpBody, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let message = json["message"].stringValue
                switch message{
                case "Updated user":
                    completion(.success(true))
                case "No access token given":
                    completion(.failure(RequestError.noAccessToken(msg:message)))
                case "No authentication":
                    completion(.failure(RequestError.noAuthentication(msg:message)))
                default:
                    completion(.failure(AFError.invalidURL(url: url)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //Delete User account from the database   ----- not tested
    static func deleteUser(completion: @escaping (Result<Bool>) -> ()){
        let url = "\(String(WeatAPIUrl))/user"
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!
        ]
        Alamofire.request(url, method:.delete, parameters: params, encoding:URLEncoding.httpBody, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let message = json["message"].stringValue
                switch message{
                case "User has been deleted":
                    completion(.success(true))
                case "No access token given":
                    completion(.failure(RequestError.noAccessToken(msg: message)))
                case "No authentication":
                    completion(.failure(RequestError.noAuthentication(msg: message)))
                default:
                    completion(.failure(AFError.invalidURL(url: url)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

