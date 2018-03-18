//
//  WeatTests.swift
//  WeatTests
//
//  Created by ctydw on 2018/2/13.
//  Copyright © 2018年 Weat. All rights reserved.
//

import XCTest
@testable import Weat

/*
 * This class will be used to test Restaurant class
 * Tests for other classes will be created in separate classes
 */

class WeatTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    /*
     * This function will be implemented to test UpdateRestaurantRating()
     */
    func testRestaurantRating(){
        let r = Restaurant()
        r.google_link = "link"
        r.name = "restaurant"
        r.updateRestaurantRating(){status in
            if(status){print(r)}
        }
    }
    
    // This test will be moved to TestFavorite class
    func testPostFavorite(){
        Favorite.addFavoriteRestaurant(google_link: "link"){ status in
            if (status) {
                print("success")
            }else{
                print("failed")
            }
        }
    }
    
    // This test will be moved to TestFavorite class
    func testDeleteFavorite(){
        Favorite.deleteFavoriteRestaurant(google_link: "link"){ status in
            if (status) {
                print("success")
            }else{
                print("failed")
            }
        }
    }
    
    /*
     * This function will be implemented to test updateRestaurantMenuWithRating()
     * When this function is executed, the menu with ratings(comments) will be pulled from the server
     * and stored inside the menu arraylist
     */
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
    
    /*
     * This function will be implemented to test updateRestaurant()
     * When this function is executed, all the infomation about the restaurant will be pulled and stored in self
     */
    func testUpdateRestaurant(){
    }
    
    /*
     * This function will be implemented to test updateRestaurantComments()
     */
    func testUpdateRestaurantComments(){
        let r = Restaurant()
        r.google_link = "kfc_link"
        r.name = "kfc"
        r.updateRestaurantComments(){_ in
            print(r.name)
        }
    }
    
    /*
     * This function will be implemented to test updateRestaurantRating()
     */
    func testUpdateRestaurantRating(){
        let r = Restaurant()
        r.google_link = "kfc_link"
        r.name = "kfc"
        r.updateRestaurantRating(){_ in
            print(r.rating.food_bad_friends)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
