//
//  Rating.swift
//  Weat
//
//  Created by ctydw on 3/10/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import Foundation
class Rating {
    /*
     * This class stores ratings for both menu items and restaurants
     * No static method in this class
     */
    
    var id: Int?
    // The writer/author of this rating
    var author: String?
    
    var restaurant_id: Int?
    var food_rating: Int?
    var service_rating: Int?
    var rating_text: String?
    var menu_item_id: Int?
    var time: Date?
}
