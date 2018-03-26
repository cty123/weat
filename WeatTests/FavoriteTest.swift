//
//  FavoriteTest.swift
//  WeatTests
//
//  Created by ctydw on 3/21/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import Foundation
import XCTest
@testable import Weat

public class FavoriteTest: XCTestCase{
    
    /*
    * Set a existing restaurant to be the favorite restaurant,
    * This restaurant should be successfully added
    */
    func testPostFavorite1(){
        let exp = expectation(description: "testPostFavorite1")
        Favorite.addFavoriteRestaurant(google_link: "kfc_link", restaurant_name: "kfc") { (status) in
            if (status) {
                print("success")
            }else{
                print("failed")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    /*
     * Set a Non-existing restaurant to be the favorite restaurant,
     * But our backend server should handle that,
     * So instead, this call will succeed and the server will create a new restaurant
     * Result: This restaurant should be successfully added
     */
    func testPostFavorite2(){
        let exp = expectation(description: "testPostFavorite2")
        Favorite.addFavoriteRestaurant(google_link: "no_such_a_link", restaurant_name: "restaurant") { (status) in
            if (status) {
                print("success")
            }else{
                print("failed")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    func testDeleteFavorite1(){
        let exp = expectation(description: "testDeleteFavorite1")
        Favorite.deleteFavoriteRestaurant(restaurant_name: "kfc",google_link: "kfc_link"){ status in
            if (status) {
                print("success")
            }else{
                print("failed")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
}
