import Foundation
import Alamofire
import SwiftyJSON
import FBSDKCoreKit

class User: Decodable{
    var id: Int?
    var name: String?
    var email: String?
    var phone: String?
    var location: String?
    var privacy: Int?
    
    // Get User info
    static func getUserInfo(profile_id:String, completion: @escaping (User) -> ()){
        let url = "http://127.0.0.1:8000/user/profile"
        let params = [
            "access_token" : FBSDKAccessToken.current().tokenString!,
            "profile_id" : profile_id
        ]
        let user = User()
        Alamofire.request(url, method:.get, parameters:params).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                user.name = json["user"]["name"].string
                user.location = json["user"]["location"].string
                user.email = json["user"]["email"].string
                user.id = json["user"]["id"].int
                user.privacy = json["user"]["privacy"].int
                user.phone = json["user"]["phone"].string
                print(user)
            case .failure(let error):
                print(error)
            }
            completion(user)
        }
    }
    
    // Change user profile
    func updateUserInfo(completion: @escaping (Bool) -> ()){
        let url = "http://127.0.0.1:8000/user/profile"
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
    
    //Delete User account from the database   ----- not tested
    func deleteUser(completion: @escaping (Bool) -> ()){
        let url = "http://127.0.0.1:8000/user"
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

