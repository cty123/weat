import Foundation
import Alamofire
import SwiftyJSON
import FBSDKCoreKit

class Feed {
    var message: String = "Not OK"
    var data: [FeedElement] = []
    var dataUnarchived: [FeedElement] = []
    
    static func getFeed(feed_type: String, completion: @escaping (Feed) -> Void) {
        let feed = Feed()
        let token = FBSDKAccessToken.current().tokenString!
        let user_id = UserDefaults.standard.integer(forKey: "id")
        let url = "\(String(WeatAPIUrl))/user/feed\(String(describing: feed_type))?access_token=\(String(describing: token))&profile_id=\(String(describing: user_id))"
        Alamofire.request(url, method:.get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                feed.message = json["message"].string!
                for obj in json["feed"] {
                    let feed_element = FeedElement(feed_obj: obj.1)
                    feed.data.append(feed_element)
                    if (!feed_element.archived) {
                        feed.dataUnarchived.append(feed_element)
                    }
                    
                }
                break;
            case .failure(let error):
                print(error)
            }
            completion(feed)
        }

    }
    
    // archive a feed item
    static func archiveFeedItem(feed_id: String, completion: @escaping(Bool)->()){
        let url = "\(String(WeatAPIUrl))/feed"
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
            "user_id": String(describing: UserDefaults.standard.integer(forKey: "id")),
            "feed_id": feed_id
        ]
        Alamofire.request(url, method: .delete, parameters: params, encoding:URLEncoding.httpBody, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let message = json["message"]
                completion(message == "Feed item archived")
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
}

