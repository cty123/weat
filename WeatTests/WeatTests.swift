//
//  WeatTests.swift
//  WeatTests
//
//  Created by ctydw on 2018/2/13.
//  Copyright © 2018年 Weat. All rights reserved.
//

import XCTest
@testable import Weat

class WeatTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        //testRestaurantMenu()
        //testRestaurantRating()
        //testPostFavorite()
        //testDeleteFavorite()
    }
    
    func testRestaurantMenu(){
        Restaurant.getRestaurantMenu(google_link: "link"){ menu_items in
            for menu_item in menu_items{
                print("{")
                print("     \(menu_item.id!)")
                print("     \(menu_item.name!)")
                print("     \(menu_item.category!)")
                print("}")
            }
        }
    }
    
    func testRestaurantRating(){
        Restaurant.getRestaurantRating(google_link: "link"){ ratings in
            for rating in ratings{
                print("{\n\(rating.id!)\n\(rating.food_rating!)\n\(rating.service_rating!)\n\(rating.rating_text!)\n\(rating.time!)\n}")
            }
        }
    }
    
    func testPostFavorite(){
        Favorite.addFavoriteRestaurant(google_link: "link"){ status in
            if (status) {
                print("success")
            }else{
                print("failed")
            }
        }
    }
    
    func testDeleteFavorite(){
        Favorite.deleteFavoriteRestaurant(google_link: "link"){ status in
            if (status) {
                print("success")
            }else{
                print("failed")
            }
        }
    }
    
    func testRestaurantMenuWithRatings(){
        Restaurant.getRestaurantMenuWithRating(google_link: "link"){ menu_items in
            for menu_item in menu_items{
                print("{")
                print("     \(menu_item.id!)")
                print("     \(menu_item.name!)")
                print("     \(menu_item.category!)")
                print("}")
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
