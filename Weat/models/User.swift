import Foundation
import Alamofire
import SwiftyJSON

class User: Decodable{
    var id: Int?
    var name: String?
    var email: String?
    var phone: String?
    var location: String?
    var privacy: Int?
    
    static func getUserInfo(user:User, access_token:String, profile_id:String, completion: @escaping () -> Void){
        let url = "http://127.0.0.1:3000/user/profile"
        let params = [
            "access_token" : access_token,
            "profile_id" : profile_id
        ]
        Alamofire.request(url, method:.get, parameters:params).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                user.name = json["user"]["name"].string
                user.location = json["user"]["location"].string
                user.email = json["user"]["email"].string
                user.id = json["user"]["id"].int
                user.privacy = json["user"]["email"].int
                user.phone = json["user"]["phone"].string
                print(user)
            case .failure(let error):
                print(error)
            }
            completion()
        }
    }
    
    static func updateUserInfo(params:[String:String]?, completion: @escaping (Bool) -> ()){
        let url = "http://127.0.0.1:3000/user/profile"
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
    
    func deleteUser(access_token:String) -> Bool{
        let url = "http://127.0.0.1:3000/user/profile"
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let params = [
            "access_token": access_token
        ]
        var status = false
        Alamofire.request(url, method:.post, parameters: params, encoding:URLEncoding.httpBody, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                status = true
            case .failure(let error):
                status = false
            }
        }
        return status
    }
    
    func save(access_token:String) {
        // add if  condition to check for id
        let params = [
            "access_token": access_token,
            "id" : self.id.map(String.init)!,
            "name": self.name!,
            "email" : self.email!,
            "phone": self.phone!,
            "location": self.location!,
            "privacy": self.privacy.map(String.init)!
        ]
        User.updateUserInfo(params: params){ status in
            if(status){
                print("success")
            }else{
                print("failed")
            }
        }
    }
}

