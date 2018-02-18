import Foundation
import SwiftyJSON

class FeedElement: Decodable{
    var restaurant: String?
    var feed_text: String?
    var user: User?
    var user_id: Int?
    var friend: User?
    var friend_id: Int?
    var id: Int?
    var createdAt: Int?
    var updatedAt: Int?
    var restaurant_id: Int?
    
    static func getFeedElement(feed_obj: JSON) -> FeedElement {
        let element:FeedElement = FeedElement()
        element.restaurant = feed_obj["restaurant"].string
        element.feed_text = feed_obj["feed_text"].string
        print(element.feed_text as Any)
    
        print(element)
        return element
    }
}
