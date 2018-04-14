//
//  Errors.swift
//  Weat
//  This class defines all the error conditions
//  Created by ctydw on 4/13/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import Foundation
enum RequestError: Error{
    case noAccessToken(msg:String)
    case noGoogleLink(msg:String)
    case noRestaurantName(msg:String)
    case noLocation(msg:String)
    case noProfileId(msg:String)
    case notAllowed(msg:String)
    case noAuthentication(msg:String)
    case noIdGiven(msg:String)
    case noUserFound(msg:String)
    case alreadySent(msg:String)
    case noFriendId(msg:String)
    case unknownError(msg:String)
}
