import Foundation
import SwiftyJSON

class FeedElement: Decodable{
    var restaurant_name: String
    var restaurant_id: Int
    
    var feed_text: String
    var feed_id: Int
    var createdAt: Int
    
    var actor_name: String
    var actor_id: Int
    
    var receiver_name: String
    var receiver_id: Int
    
    
    init(feed_obj: JSON) {
        restaurant_name = (feed_obj["restaurant"]["name"].string != nil ? feed_obj["restaurant"]["name"].string! : "")
        restaurant_id = (feed_obj["restaurant_id"].int != nil ? feed_obj["restaurant_id"].int! : -1)
        
        feed_text = (feed_obj["feed_text"].string != nil ? feed_obj["feed_text"].string! : "")
        feed_id = (feed_obj["id"].int != nil ? feed_obj["id"].int! : -1)
        createdAt = (feed_obj["createdAt"].int != nil ? feed_obj["createdAt"].int! : -1)
        
        actor_name = (feed_obj["user"]["name"].string != nil ? feed_obj["user"]["name"].string! : "")
        actor_id = (feed_obj["user"]["id"].int != nil ? feed_obj["user"]["id"].int! : -1)
        
        receiver_name = (feed_obj["friend"]["name"].string != nil ? feed_obj["friend"]["name"].string! : "")
        receiver_id = (feed_obj["friend"]["id"].int != nil ? feed_obj["friend"]["id"].int! : -1)
        
    }
}
