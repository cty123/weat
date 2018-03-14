//
//  Menu_item.swift
//  Weat
//
//  Created by ctydw on 3/10/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import Foundation
class Menu_item{
    /**
     * This model is to store menu items. An array of menu items will constitute a menu for a restaurant
     * No static functions in menu item model
     */
    var name:String?
    var category: String?
    var rating = [Rating]()
    var id: Int?
}
