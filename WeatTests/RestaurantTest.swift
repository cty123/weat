//
//  RestaurantTest.swift
//  WeatTests
//
//  Created by ctydw on 3/21/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import Foundation
import XCTest
@testable import Weat

public class RestaurantTest: XCTestCase{
    
    /*
     * This function will be implemented to test UpdateRestaurantRating()
     */
    func testGetRestaurantRating1(){
        let exp = expectation(description: "testGetRestaurantRating1")
        let r = Restaurant()
        r.google_link = "link"
        r.name = "restaurant"
        r.getRestaurantRating(){status in
            if(status){
                XCTAssert(status)
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    /*
     * This function will be implemented to test updateRestaurantMenuWithRating()
     * When this function is executed, the menu with ratings(comments) will be pulled from the server
     * and stored inside the menu arraylist
     */
    func testRestaurantMenuWithRating1(){
        let exp = expectation(description: "testRestaurantMenuWithRating1")
        let r = Restaurant()
        r.google_link = "kfc_link"
        r.name = "kfc"
        r.getRestaurantMenuWithRating(){status in
            if(status){
                XCTAssert(status)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    func testGetRestaurant1(){
        let exp = expectation(description: "testGetRestaurant1")
        let r = Restaurant()
        r.google_link = "kfc_link"
        r.name = "kfc"
        r.getRestaurant(){status in
            if(status){
                XCTAssert(status)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    func testUpdateRestaurantComments1(){
        let exp = expectation(description: "testUpdateRestaurantComments1")
        let r = Restaurant()
        r.google_link = "kfc_link"
        r.name = "kfc"
        r.getRestaurantComments(){status in
            if(status){
                XCTAssert(status)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    /*
     * This function will be implemented to test updateRestaurantRating()
     */
    func testUpdateRestaurantRating1(){
        let exp = expectation(description: "testUpdateRestaurantRating1")
        let r = Restaurant()
        r.google_link = "kfc_link"
        r.name = "kfc"
        r.getRestaurantRating(){status in
            if(status){
                XCTAssert(status)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    
}
