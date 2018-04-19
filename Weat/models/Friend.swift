import Foundation
import Alamofire
import SwiftyJSON
import FBSDKCoreKit

class Friend {

    /*
    * Check if someone is your friend
    * No relationship yet: -1
    * 0 pending, 1 accept, 2 deny
    */
    static func getStatus(id: String, completion: @escaping (Result<Int>) -> ()){
        let url = "\(String(WeatAPIUrl))/user/friends/status"
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
            "id": id
        ]
        Alamofire.request(url, method:.get, parameters:params).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let message = json["message"].stringValue
                // Check if the request is successful
                switch message{
                case "OK":
                    let status = json["status"].intValue
                    completion(.success(status))
                case "No access token given":
                    completion(.failure(RequestError.noAccessToken(msg: message)))
                case "No id given":
                    completion(.failure(RequestError.noIdGiven(msg: message)))
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
                let message = json["message"].stringValue
                switch message{
                case "OK":
                    for friend in json["friends"].arrayValue{
                        let tmpUser = User()
                        tmpUser.id = friend["joinFriend"]["id"].intValue
                        tmpUser.name = friend["joinFriend"]["name"].stringValue
                        tmpUser.email = friend["joinFriend"]["email"].stringValue
                        tmpUser.phone = friend["joinFriend"]["phone"].stringValue
                        tmpUser.location = friend["joinFriend"]["location"].stringValue
                        tmpUser.privacy = friend["joinFriend"]["privacy"].intValue
                        tmpUser.facebook_link = friend["joinFriend"]["facebook_link"].stringValue
                        users.append(tmpUser)
                    }
                    completion(.success(users))
                case "No access token given":
                    completion(.failure(RequestError.noAccessToken(msg: message)))
                case "No profile id given":
                    completion(.failure(RequestError.noProfileId(msg: message)))
                case "Not allowed":
                    completion(.failure(RequestError.notAllowed(msg: message)))
                case "No authentication":
                    completion(.failure(RequestError.noAuthentication(msg: message)))
                case "No user found":
                    completion(.failure(RequestError.noUserFound(msg: message)))
                default:
                    completion(.failure(RequestError.unknownError(msg: message)))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    // send friend request
    static func sendFriendRequest(friend_id:String, completion: @escaping(Result<Bool>)->()){
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
                let message = json["message"].stringValue
                switch message{
                case "Friend request sent":
                    completion(.success(true))
                case "No access token given":
                    completion(.failure(RequestError.noAccessToken(msg: message)))
                case "No friend id given":
                    completion(.failure(RequestError.noFriendId(msg: message)))
                case "No authentication":
                    completion(.failure(RequestError.noAuthentication(msg: message)))
                case "User does not exist":
                    completion(.failure(RequestError.noUserFound(msg: message)))
                case "Already sent":
                    completion(.failure(RequestError.alreadySent(msg: message)))
                default:
                    completion(.failure(RequestError.unknownError(msg: message)))
                }
            case .failure(let error):
                completion(.failure(error))
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
                let message = json["message"].stringValue
                switch message{
                case "OK":
                    for friend in json["pending_friends"].arrayValue{
                        let tmpUser = User()
                        tmpUser.id = friend["joinUser"]["id"].intValue
                        tmpUser.name = friend["joinUser"]["name"].stringValue
                        tmpUser.email = friend["joinUser"]["email"].stringValue
                        tmpUser.phone = friend["joinUser"]["phone"].stringValue
                        tmpUser.location = friend["joinUser"]["location"].stringValue
                        tmpUser.privacy = friend["joinUser"]["privacy"].intValue
                        tmpUser.facebook_link = friend["joinUser"]["facebook_link"].stringValue
                        users.append(tmpUser)
                    }
                    completion(.success(users))
                case "No access token given":
                    completion(.failure(RequestError.noAccessToken(msg: message)))
                case "No authentication":
                    completion(.failure(RequestError.noAuthentication(msg: message)))
                default:
                    completion(.failure(RequestError.unknownError(msg: message)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    /**
     * acceptance -- 0 pending, 1 accept, 2 deny
     */
    // Accept or reject friend request
    static func setFriendRequest(friend_id: Int, acceptance: Int, completion: @escaping(Result<Bool>)->()){
        let url = "\(String(WeatAPIUrl))/user/friends/pending"
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
            "acceptance": String(acceptance),
            "friend_id": String(friend_id)
        ]
        Alamofire.request(url, method:.post, parameters: params, encoding:URLEncoding.httpBody, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let message = json["message"].stringValue
                switch message{
                case "Friend request sent":
                    completion(.success(true))
                case "No access token given":
                    completion(.failure(RequestError.noAccessToken(msg: message)))
                case "No authentication":
                    completion(.failure(RequestError.noAuthentication(msg: message)))
                default:
                    completion(.failure(RequestError.unknownError(msg: message)))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    /*
    * Search for a user or users for a given criteria
    * The page and limit can be set to nil when you want to use the default value
    */
    static func searchFriend(search_criteria:String, page: Int?, limit: Int?, completion:@escaping(Result<([User])>)->()){
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
                let message = json["message"].stringValue
                switch message {
                case "OK":
                    for friend in json["users"].arrayValue{
                        let tmpUser = User()
                        tmpUser.id = friend["id"].intValue
                        tmpUser.name = friend["name"].stringValue
                        tmpUser.email = friend["email"].stringValue
                        tmpUser.phone = friend["phone"].stringValue
                        tmpUser.location = friend["location"].stringValue
                        tmpUser.privacy = friend["privacy"].intValue
                        tmpUser.facebook_link = friend["facebook_link"].stringValue
                        users.append(tmpUser)
                    }
                    completion(.success(users))
                case "No access token given":
                    completion(.failure(RequestError.noAccessToken(msg: message)))
                case "No authentication":
                    completion(.failure(RequestError.noAuthentication(msg: message)))
                case "No search criteria given":
                    completion(.failure(RequestError.noSearchCriteria(msg: message)))
                default:
                    completion(.failure(RequestError.unknownError(msg: message)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    /*
     *  Add facebook friends who are also the user of Weat
     *  facebook_link can contain multiple facebook links separated by ','
     */
    static func addFacebookFriends(facebook_links:String, completion:@escaping (Result<Bool>)->()){
        let url = "\(String(WeatAPIUrl))/user/friends/facebook_friends"
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
            "facebook_links": facebook_links
        ]
        Alamofire.request(url, method:.post, parameters: params, encoding:URLEncoding.httpBody, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let message = json["message"].stringValue
                switch message{
                case "Friends added":
                    completion(.success(true))
                case "No access token given":
                    completion(.failure(RequestError.noAccessToken(msg: message)))
                case "No authentication":
                    completion(.failure(RequestError.noAuthentication(msg: message)))
                case "No facebook ids given":
                    completion(.failure(RequestError.noFacebookId(msg: message)))
                case "Invalid facebook ids parameter":
                    completion(.failure(RequestError.invalidFacebookIds(msg: message)))
                case "No friends found":
                    completion(.failure(RequestError.noFriendsFound(msg:message)))
                default:
                    completion(.failure(RequestError.unknownError(msg: message)))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
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
                let message = json["message"].stringValue
                
                switch message {
                case "OK":
                    let user = User()
                    user.name = json["user"]["name"].stringValue
                    user.location = json["user"]["location"].stringValue
                    user.email = json["user"]["email"].stringValue
                    user.id = json["user"]["id"].intValue
                    user.privacy = json["user"]["privacy"].intValue
                    user.phone = json["user"]["phone"].stringValue
                    user.facebook_link = facebook_link
                    completion(.success(user))
                case "No access token given":
                    completion(.failure(RequestError.noAccessToken(msg: message)))
                case "No authentication":
                    completion(.failure(RequestError.noAuthentication(msg: message)))
                case "No facebook link is given":
                    completion(.failure(RequestError.noFacebookId(msg: message)))
                case "No user found":
                    completion(.failure(RequestError.noUserFound(msg: message)))
                default:
                    completion(.failure(RequestError.unknownError(msg: message)))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    static func remove(id: String, completion: @escaping (Result<Bool>)->()){
        let url = "\(String(WeatAPIUrl))/user/friends"
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
            "friend_id": id
        ]
        Alamofire.request(url, method: .delete, parameters: params, encoding: URLEncoding.httpBody, headers: nil).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let message = json["message"].stringValue
                switch message{
                case "Friend deleted":
                    completion(.success(true))
                case "No access token given":
                    completion(.failure(RequestError.noAccessToken(msg: message)))
                case "No authentication":
                    completion(.failure(RequestError.noAuthentication(msg: message)))
                case "No friend id given":
                    completion(.failure(RequestError.noFriendId(msg: message)))
                case "User does not exist":
                    completion(.failure(RequestError.noUserFound(msg: message)))
                case "Friend does not exist":
                    completion(.failure(RequestError.noFriendsFound(msg: message)))
                default:
                    completion(.failure(RequestError.unknownError(msg: message)))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
}
