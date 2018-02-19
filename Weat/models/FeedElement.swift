import Foundation
import SwiftyJSON

class FeedElement: Decodable{
    var restaurant: String
    var feed_text: String
    /* Uncomment and add these fields
    var user: User
    var user_id: Int
    var friend: User
    var friend_id: Int
    var id: Int
    var createdAt: Int
    var updatedAt: Int
    var restaurant_id: Int*/
    
    static func makeFeedElement(feed_obj: JSON) -> FeedElement {
        let element = FeedElement()
        //element.restaurant = feed_obj["restaurant"].string
        //element.feed_text = feed_obj["feed_text"].string
        
        /* Dummy values */
        //element.restaurant = "restaurant dummy"
        element.feed_text = "feed_text dummy"
        return element
    }
    
    init() {
        restaurant = "restaurant dummy"
        feed_text = "feed_text dummy"
    }
    
    init(feed_obj: JSON) {
        if(feed_obj["restaurant"].string != nil) {
            restaurant = feed_obj["restaurant"].string!
        } else {
            restaurant = ""
        }
        feed_text = feed_obj["feed_text"].string!
    }
}
