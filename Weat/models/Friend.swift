import Foundation
import Alamofire
import SwiftyJSON
import FBSDKCoreKit

class Friend {

    //Get friends of this user
    static func getFriends(profile_id:String, completion: @escaping (([User])) -> ()){
        let url = "\(String(WeatAPIUrl))/user/friends"
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
            "profile_id": profile_id
        ]
        var users = [User]()
        Alamofire.request(url, method:.get, parameters:params).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for friend in json["friends"].arrayValue{
                    let tmpUser = User()
                    tmpUser.id = friend["joinFriend"]["id"].intValue
                    tmpUser.name = friend["joinFriend"]["name"].stringValue
                    tmpUser.email = friend["joinFriend"]["email"].stringValue
                    tmpUser.phone = friend["joinFriend"]["phone"].stringValue
                    tmpUser.location = friend["joinFriend"]["location"].stringValue
                    tmpUser.privacy = friend["joinFriend"]["privacy"].intValue
                    users.append(tmpUser)
                }
            case .failure(let error):
                print(error)
            }
            completion(users)
        }
    }
    
    // send friend request
    static func sendFriendRequest(friend_id:String, completion: @escaping(Bool)->()){
        let url = "\(String(WeatAPIUrl))/user/friends"
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
            "friend_id": friend_id
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
    
    // pull friend request
    static func pullFriendRequest(completion:@escaping(([User]))->()){
        let url = "\(String(WeatAPIUrl))/user/friends/pending"
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!
        ]
        var users = [User]()
        Alamofire.request(url, method:.get, parameters:params).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for friend in json["pending_friends"].arrayValue{
                    let tmpUser = User()
                    tmpUser.id = friend["joinUser"]["id"].intValue
                    tmpUser.name = friend["joinUser"]["name"].stringValue
                    tmpUser.email = friend["joinUser"]["email"].stringValue
                    tmpUser.phone = friend["joinUser"]["phone"].stringValue
                    tmpUser.location = friend["joinUser"]["location"].stringValue
                    tmpUser.privacy = friend["joinUser"]["privacy"].intValue
                    users.append(tmpUser)
                }
            case .failure(let error):
                print(error)
            }
            completion(users)
        }
    }
    /**
     * acceptance -- 0 pending, 1 accept, 2 deny
     */
    // Accept or reject friend request
    static func setFriendRequest(friend_id: String, acceptance: Int, completion: @escaping(Bool)->()){
        let url = "\(String(WeatAPIUrl))/user/friends/pending"
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
            "acceptance": String(acceptance),
            "friend_id": friend_id
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
    
    // Search friend
    static func searchFriend(search_criteria:String, page: Int?, limit: Int?, completion:@escaping(([User]))->()){
        let url = "\(String(WeatAPIUrl))/user/friends/search"
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
            "search_criteria": search_criteria,
        ]
        var users = [User]()
        Alamofire.request(url, method:.get, parameters:params).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for friend in json["users"].arrayValue{
                    let tmpUser = User()
                    tmpUser.id = friend["id"].intValue
                    tmpUser.name = friend["name"].stringValue
                    tmpUser.email = friend["email"].stringValue
                    tmpUser.phone = friend["phone"].stringValue
                    tmpUser.location = friend["location"].stringValue
                    tmpUser.privacy = friend["privacy"].intValue
                    users.append(tmpUser)
                }
            case .failure(let error):
                print(error)
            }
            completion(users)
        }
    }
    
    // Add facebook friend          ---- not tested
    static func addFacebookFriends(facebook_links:String, completion:@escaping (Bool)->()){
        let url = "\(String(WeatAPIUrl))/user/friends/search"
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
            "facebook_links": facebook_links
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
}
