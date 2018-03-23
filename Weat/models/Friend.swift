import Foundation
import Alamofire
import SwiftyJSON
import FBSDKCoreKit

class Friend {

    //Get friends of this user
    static func getFriends(profile_id:String, completion: @escaping (Result<([User])>) -> ()){
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
                let message = json["message"]
                // Check if the request is successful
                if message == "OK" {
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
                    completion(.success(users))
                }else{
                    completion(.failure(AFError.invalidURL(url: url)))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
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
        Alamofire.request(url, method:.post, parameters: params, encoding:URLEncoding.httpBody, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let message = json["message"]
                completion(message == "Friend request sent")
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    // pull friend request
    static func pullFriendRequest(completion:@escaping(Result<([User])>)->()){
        let url = "\(String(WeatAPIUrl))/user/friends/pending"
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!
        ]
        var users = [User]()
        Alamofire.request(url, method:.get, parameters:params).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let message = json["message"]
                if message == "OK" {
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
                    completion(.success(users))
                }else {
                    completion(.failure(AFError.invalidURL(url: url)))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    /**
     * acceptance -- 0 pending, 1 accept, 2 deny
     */
    // Accept or reject friend request
    static func setFriendRequest(friend_id: Int, acceptance: Int, completion: @escaping(Bool)->()){
        let url = "\(String(WeatAPIUrl))/user/friends/pending"
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
            "acceptance": String(acceptance),
            "friend_id": String(friend_id)
        ]
        var status = false
        Alamofire.request(url, method:.post, parameters: params, encoding:URLEncoding.httpBody, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let message = json["message"]
                status = true
            case .failure(let error):
                print(error)
            }
            completion(status)
        }
    }
    
    /*
    * Search for a user or users for a given criteria
    * The page and limit can be set to nil when you want to use the default value
    */
    static func searchFriend(search_criteria:String, page: Int?, limit: Int?, completion:@escaping(([User]))->()){
        let url = "\(String(WeatAPIUrl))/user/friends/search"
        var params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
            "search_criteria": search_criteria,
        ]
        if page != nil {
            params["page"] = String(describing: page)
        }
        if limit != nil {
            params["limit"] = String(describing: limit)
        }
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
    
    /*
     *  Add facebook friends who are also the user of Weat
     *  facebook_link can contain multiple facebook links separated by ','
     */
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
                let message = json["message"]
                status = true
            case .failure(let error):
                print(error)
            }
            completion(status)
        }
    }
    
    static func getUserByFacebookLink(facebook_link:String, completion: @escaping (Result<User>)->()){
        let url = "\(String(WeatAPIUrl))/user/friends/facebook_link"
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
            "facebook_link": facebook_link
        ]
        Alamofire.request(url, method:.get, parameters:params).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let message = json["message"]
                if message == "OK"{
                    let user = User()
                    user.name = json["user"]["name"].stringValue
                    user.location = json["user"]["location"].stringValue
                    user.email = json["user"]["email"].stringValue
                    user.id = json["user"]["id"].intValue
                    user.privacy = json["user"]["privacy"].intValue
                    user.phone = json["user"]["phone"].stringValue
                    completion(.success(user))
                }else{
                    completion(.failure(AFError.invalidURL(url: url)))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
}
