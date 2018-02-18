import Foundation
import Alamofire
import SwiftyJSON
import FBSDKCoreKit

class Feed: Decodable{
    var message: String?
    var data: [FeedElement]?
    
    static func getFeed(feed_type: String, feed: Feed, completion: @escaping () -> Void) {
        let token = FBSDKAccessToken.current().tokenString!
        let user_id = UserDefaults.standard.integer(forKey: "id")
        let url = "http://127.0.0.1:8000/user/feed\(String(describing: feed_type))?access_token=\(String(describing: token))&profile_id=\(String(describing: user_id))"
        let feed:Feed = Feed()
        print(url as Any)
        Alamofire.request(url, method:.get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                feed.message = json["message"].string
                print(feed.message as Any)
                for obj in json["feed"] {
                    print("here")
                    feed.data?.append(FeedElement.makeFeedElement(feed_obj: obj.1))
                }
                
                print(feed.data)
            case .failure(let error):
                print(error)
        
            completion()
            }
        }
        
    }
    
    static func getData(array: JSON) {
        
    }
}

