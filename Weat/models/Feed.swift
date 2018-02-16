import Foundation
import Alamofire
import SwiftyJSON
import FBSDKCoreKit

class Feed: Decodable{
    var message: String?
    var data: Data?
    
    static func getYouFeed() -> Feed {
        let token = FBSDKAccessToken.current().tokenString!
        let user_id = UserDefaults.standard.integer(forKey: "id")
        let url = "http://127.0.0.1:8000/user/feed?access_token=\(String(describing: token))&profile_id=\(String(describing: user_id))"
        let feed:Feed = Feed()
        print(url as Any)
        Alamofire.request(url, method:.get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                feed.message = json["message"].string
                feed.data = try? json["feed"].rawData()
                print(feed)
            case .failure(let error):
                print(error)
            }
        }
        return feed
    }
}



