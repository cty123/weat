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
    
    func testRestaurantRating(){
        let r = Restaurant()
        r.google_link = "link"
        r.name = "restaurant"
        r.updateRestaurantRating(){status in
            if(status){print(r)}
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
    
    func testRestaurantMenuWithRating(){
        print("----Testing menu with rating----")
        let r = Restaurant()
        r.google_link = "kfc_link"
        r.name = "kfc"
        r.updateRestaurantMenuWithRating(){status in
            if(status){
                //print(r.menu[0].rating[0].author!)
            }
            print("----End of menu with rating----")
        }
    }
    
    func testUpdateRestaurant(){
        let r = Restaurant()
        r.google_link = "kfc_link"
        r.name = "kfc"
        r.updateRestaurant(){_ in
            print("Testing update restaurant")
            print(r)
        }
    }
    
    func testUpdateRestaurantComments(){
        let r = Restaurant()
        r.google_link = "kfc_link"
        r.name = "kfc"
        r.updateRestaurantComments(){_ in
            print(r.name)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
