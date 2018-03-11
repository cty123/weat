//
//  Rating.swift
//  Weat
//
//  Created by ctydw on 3/10/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import Foundation
class Rating {
    var id: Int?
    // The writer/author of this rating
    var author: User?
    
    var restaurant_id: Int?
    var food_rating: Int?
    var service_rating: Int?
    var rating_text: String?
    var menu_item_id: Int?
    var time: Date?
}
