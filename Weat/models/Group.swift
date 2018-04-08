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
    
    // Get all the groups the user is in
    static func getAll(completion: @escaping(Result<([Group])>)->()){
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
                    for group in json["groups"].arrayValue{
                        let g = Group()
                        g.id = group["group"]["id"].intValue
                        g.name = group["group"]["name"].stringValue
                        g.icon_id = group["group"]["icon_id"].intValue
                        groups.append(g)
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
    
    // Create a new group
    static func create(group_name:String, icon_id: Int, completion: @escaping(Bool)->()){
        let url = "\(String(WeatAPIUrl))/groups"
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
            "group_name": group_name,
            "group_icon_id": String(icon_id),
        ]
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        Alamofire.request(url, method:.post, parameters: params, encoding:URLEncoding.httpBody, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let message = json["message"].stringValue
                if message == "Created group" {
                    completion(true)
                }else{
                    completion(false)
                }
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    // Leave a group
    static func leave(group_id:Int, completion: @escaping(Bool)->()){
        let url = "\(String(WeatAPIUrl))/groups"
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
            "group_id": String(group_id),
        ]
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        Alamofire.request(url, method:.delete, parameters: params, encoding:URLEncoding.httpBody, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let message = json["message"].stringValue
                if message == "Group left" {
                    completion(true)
                }else{
                    completion(false)
                }
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    //Edit a group
    static func edit(group_id:Int, group_name:String, group_icon_id: Int, completion: @escaping(Bool)->()){
        let url = "\(String(WeatAPIUrl))/groups/edit"
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
            "group_id": String(group_id),
            "group_name": group_name,
            "group_icon_id": String(group_icon_id)
        ]
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        Alamofire.request(url, method:.post, parameters: params, encoding:URLEncoding.httpBody, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let message = json["message"].stringValue
                if message == "Updated group" {
                    completion(true)
                }else{
                    completion(false)
                }
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    // Get left groups
    static func getLeft(completion: @escaping(Result<[Group]>)->()){
        let url = "\(String(WeatAPIUrl))/groups/rejoin"
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
                    for group in json["groups"].arrayValue{
                        let g = Group()
                        g.id = group["group"]["id"].intValue
                        g.name = group["group"]["name"].stringValue
                        g.icon_id = group["group"]["icon_id"].intValue
                        groups.append(g)
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
    
    // Rejoin a group
    static func rejoin(group_id:Int, completion: @escaping(Bool)->()){
        let url = "\(String(WeatAPIUrl))/groups/rejoin"
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
            "group_id": String(group_id),
        ]
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        Alamofire.request(url, method:.post, parameters: params, encoding:URLEncoding.httpBody, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let message = json["message"].stringValue
                if message == "Rejoined group" {
                    completion(true)
                }else{
                    completion(false)
                }
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    // invite friend to group, can invite multiple friends
    static func invite(group_id:Int, friend_ids:String, completion: @escaping(Bool)->()){
        let url = "\(String(WeatAPIUrl))/groups/invite"
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
            "group_id": String(group_id),
            "friend_ids": friend_ids
            ]
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        Alamofire.request(url, method:.post, parameters: params, encoding:URLEncoding.httpBody, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let message = json["message"].stringValue
                if message == "Invites sent" {
                    completion(true)
                }else{
                    completion(false)
                }
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    // get group members
    static func getMembers(group_id:Int, completion: @escaping(Result<[User]>)->()){
        let url = "\(String(WeatAPIUrl))/groups/members"
        let params = [
            "access_token": FBSDKAccessToken.current().tokenString!,
            "group_id": String(group_id)
            ]
        var users = [User]()
        Alamofire.request(url, method:.get, parameters:params).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let message = json["message"].stringValue
                if message == "OK" {
                    for user in json["members"].arrayValue{
                        let u = User()
                        u.id = user["user"]["id"].intValue
                        u.name = user["user"]["name"].stringValue
                        u.email = user["user"]["email"].stringValue
                        u.phone = user["user"]["phone"].stringValue
                        u.location = user["user"]["location"].stringValue
                        u.privacy = user["user"]["privacy"].intValue
                        users.append(u)
                    }
                    completion(.success(users))
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
