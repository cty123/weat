//
//  Comment.swift
//  Weat
//
//  Created by ctydw on 3/14/18.
//  Copyright © 2018 Weat. All rights reserved.
//

/*
 * This class is a datatype to store restaurant comments from friends
 */
import Foundation
class Comment{
    var id: Int?
    var authorID: Int?
    var author_FB_link: String?
    var restaurant_id: Int? 
    var comment_text: String?
    var author: String?
    var food_rating: Int?
    var service_rating: Int?
    var time: Date?
}
