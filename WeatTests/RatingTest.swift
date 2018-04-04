//
//  RatingTest.swift
//  WeatTests
//
//  Created by ctydw on 3/25/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import Foundation
import XCTest
@testable import Weat

public class RatingTest:XCTestCase {
    
    /*
     * Testing databse
     ------------------------------ratings-------------------------------
     id    user_id    restaurant_id    food_rating    service_rating    rating_text    menu_item_id    createdAt    updatedAt
     1    1    1    1    1    So good    NULL    2018-01-01 00:00:00    2018-01-01 00:00:00
     2    1    1    1    NULL    This chicken is so good    1    2018-01-01 00:00:00    2018-01-01 00:00:00
     */
    
    
    func testPostRestaurantRating1(){
        let exp = expectation(description: "testPostRestaurantRating1")
        Rating.postRestaurantRating(google_link: "test_link", restaurant_name: "test_restaurant", food_rating: 1, service_rating: 1, rating_text: "TestRating1"){ status in
            if (status){
                let r = Restaurant();
                r.name = "test_restaurant"
                r.google_link = "test_link"
                r.getRestaurantComments(){s in
                    if(s){
                        XCTAssert(r.comments[0].comment_text == "TestRating1")
                        exp.fulfill()
                    }else{
                        XCTAssert(false)
                    }
                }
            }else{
                XCTAssert(false)
            }
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    func testPostRestaurantRating2(){
        let exp = expectation(description: "testPostRestaurantRating2")
        Rating.postRestaurantRating(google_link: "test_link", restaurant_name: "test_restaurant", food_rating: 0, service_rating: 0, rating_text: "TestRating2"){ status in
            if (status){
                let r = Restaurant()
                r.name = "test_restaurant"
                r.google_link = "test_link"
                r.getRestaurantComments(){s in
                    if(s){
                        XCTAssert(r.comments[1].comment_text == "TestRating2")
                        exp.fulfill()
                    }else{
                        XCTAssert(false)
                    }
                }
            }else{
                XCTAssert(false)
            }
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    func testPostRestaurantRating3(){
        let exp = expectation(description: "testPostRestaurantRating3")
        let r = Restaurant()
        r.name = "test_restaurant"
        r.google_link = "test_link"
        r.getRestaurantRating(){status in
            if(status){
                XCTAssert(r.rating.food_good_all == 1)
                exp.fulfill()
            }else{
                XCTAssert(false)
            }
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    func testPostMenuItemRating1(){
        let exp = expectation(description: "testPostMenuItemRating1")
        Rating.postMenuItemRating(google_link: "test_link", restaurant_name: "test_restaurant", menu_item_id: 3, food_rating: 1, rating_text: "I like it"){status in
            if status {
                XCTAssert(true)
                exp.fulfill()
            }else{
                XCTAssert(false)
            }
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    func testPostMenuItemRating2(){
        let exp = expectation(description: "testPostMenuItemRating2")
        Rating.postMenuItemRating(google_link: "testPostMenuItemRating2_link", restaurant_name: "testPostMenuItemRating2_restaurant", menu_item_id: 3, food_rating: 1, rating_text: "I like it"){status in
            if status {
                XCTAssert(true)
                exp.fulfill()
            }else{
                XCTAssert(false)
            }
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    func testPostMenuItemRating3(){
        let exp = expectation(description: "testPostMenuItemRating3")
        Rating.postMenuItemRating(google_link: "test_link", restaurant_name: "test_restaurant", menu_item_id: 3, food_rating: 1, rating_text: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"){status in
            if status {
                XCTAssert(true)
                exp.fulfill()
            }else{
                XCTAssert(false)
            }
        }
        wait(for: [exp], timeout: 10.0)
    }
    
}
