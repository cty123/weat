import Foundation
import Alamofire
import SwiftyJSON
import FBSDKCoreKit

class Feed {
    var message: String = "Not OK"
    var data: [FeedElement] = []
    
    static func getFeed(feed_type: String, completion: @escaping (Feed) -> Void) {
        let feed = Feed()
        let token = FBSDKAccessToken.current().tokenString!
        let user_id = UserDefaults.standard.integer(forKey: "id")
        let url = "\(String(WeatAPIUrl))/user/feed\(String(describing: feed_type))?access_token=\(String(describing: token))&profile_id=\(String(describing: user_id))"
        print(url as Any)
        Alamofire.request(url, method:.get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                feed.message = json["message"].string!
                print(json)
                for obj in json["feed"] {
                    let feed_element = FeedElement(feed_obj: obj.1)
                    feed.data.append(feed_element)
                }
                break;
            case .failure(let error):
                print(error)
            }
            completion(feed)
        }

    }
}

