//
//  Group.swift
//  Weat
//
//  Created by ctydw on 4/3/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import Alamofire
import SwiftyJSON
public class Group{
    var id: Int?
    var name: String?
    var icon_id: Int?
    
    static func getAllGroups(completion: @escaping(Result<[Group]>)->()){
        let url = "\(String(WeatAPIUrl))/groups"
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
        ]
        var groups = [Group]()
        Alamofire.request(url, method:.get, parameters:params).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let message = json["message"].stringValue
                if message == "OK" {
                    for friend in json["friends"].arrayValue{
                        
                    }
                    completion(.success(groups))
                }else{
                    completion(.failure(AFError.invalidURL(url: url)))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
}
