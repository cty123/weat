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
    
    static func getUserInfo(params : [String : String]?) -> User {
        let url = "http://127.0.0.1:8000/user/profile"
        let user:User = User()
        Alamofire.request(url, method:.get, parameters:params).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                let user:User = User()
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
        }
        return user
    }
}

