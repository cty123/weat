//
//  Restaurant.swift
//  Weat
//
//  Created by Sean Becker on 2/22/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import Foundation
import SwiftyJSON

class Restaurant {
    var latitude: Double
    var longitude: Double
    var name: String
    
    init(json: JSON) {
        latitude = (json["geometry"]["location"]["lat"].double != nil ? json["geometry"]["location"]["lat"].double! : 0.0)
        longitude = (json["geometry"]["location"]["lng"].double != nil ? json["geometry"]["location"]["lng"].double! : 0.0)
        name = (json["name"].string != nil ? json["name"].string! : "")
    }
}
