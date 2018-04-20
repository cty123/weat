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
     * This class is used to test API functions in restaurant class
     * Testing data *restaraurants* table
     *------------------------------------------------------------------------------
     * id       name           google_link                  createdAt    updatedAt
        1        kfc            kfc_link                          x            x
        2    Hotel Fusion     ChIJ0SMraI-AhYAREeJAvm2_yGM         x            x
        3    test_restaurant    test_link                         x            x
     * Menu item table
     *------------------------------------------------------------------------------
     * id    restaurant_id            name        category    createdAt    updatedAt
        1         1               Fried chicken    Fried          x            x
        2         1                 McNuggets      Nuggets        x            x
        3         3                    sth          sth           x            x
     *
     *-------------------------------------------------------------------------------
     */
    
    /*
     * This function will be implemented to test UpdateRestaurantRating()
     * Pull restaurant rating with TRUE name and TRUE google_link
     * Result: should pull the rating of restaurant
     */
    
    func testGetRestaurantRating1(){
        let exp = expectation(description: "testGetRestaurantRating1")
        let r = Restaurant()
        r.google_link = "test_link"
        r.name = "test"
        r.latitude = 101
        r.longitude = 21
        r.getRestaurantRating(){ result in
            switch result{
            case .success(_):
                XCTAssert(true)
            case .failure(_):
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    /*
     * Pull restaurant rating with TRUE name and FALSE google_link
     * Result: the server will create a new restaurant with name and google_link provided
     */
    func testGetRestaurantRating2(){
        let exp = expectation(description: "testGetRestaurantRating2")
        let r = Restaurant()
        r.google_link = "test2_link"
        r.name = "test2"
        r.latitude = 72
        r.longitude = 27
        r.getRestaurantRating(){result in
            switch result{
            case .success(_):
                XCTAssert(true)
            case .failure(_):
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    /*
     * Pull restaurant rating with FALSE name and TRUE google_link
     * Result: the server will create a new restaurant with name and google_link provided
     */
    func testGetRestaurantRating3(){
        let exp = expectation(description: "testGetRestaurantRating3")
        let r = Restaurant()
        r.google_link = "test3_link"
        r.name = "test3"
        r.latitude = 198
        r.longitude = 89
        r.getRestaurantRating(){result in
            switch result{
            case .success(_):
                XCTAssert(true)
            case .failure(_):
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    /*
     * Pull entire restaurant infomation
     * Test if the menu of the restuarant is fulled given the TRUE google_link and TRUE restaurant name
     */
    func testGetRestaurant1(){
        let exp = expectation(description: "testGetRestaurant1")
        let r = Restaurant()
        r.google_link = "test_link"
        r.name = "test"
        r.latitude = 101
        r.longitude = 21
        r.getRestaurant(){result in
            switch result{
            case .success(_):
                XCTAssertTrue(r.menu[0].name == "test_item")
                XCTAssert(true)
            case .failure(_):
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    /*
     * Pull the comment of the restaurant
     * Test if the comment of the restaurant is pulled
     */
    func testGetRestaurant2(){
        let exp = expectation(description: "testGetRestaurant2")
        let r = Restaurant()
        r.google_link = "test_link"
        r.name = "test"
        r.latitude = 101
        r.longitude = 21
        r.getRestaurant(){ result in
            switch result {
            case .success(_):
                XCTAssertTrue(r.comments[0].comment_text == "Good")
                XCTAssertTrue(r.comments[0].restaurant_id == 1)
                XCTAssertTrue(r.comments[0].food_rating == 1)
                XCTAssertTrue(r.comments[0].service_rating == 1)
                XCTAssertTrue(r.comments[0].author == "testuser")
                XCTAssert(true)
            case .failure(_):
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    /*
     * Pull entire restaurant infomation
     * Test if the menu of the restuarant is fulled given the TRUE google_link and FALSE restaurant name
     */
    func testGetRestaurant3(){
        let exp = expectation(description: "testGetRestaurant3")
        let r = Restaurant()
        r.google_link = "test_link"
        r.name = "test"
        r.latitude = 101
        r.longitude = 21
        r.getRestaurant(){ result in
            switch result{
            case .success(_):
                XCTAssertTrue(r.menu[0].name == "test_item")
                XCTAssert(true)
            case .failure(_):
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    /*
     * This function will be implemented to test updateRestaurantMenuWithRating()
     * When this function is executed, the menu with ratings(comments) will be pulled from the server
     * and stored inside the menu arraylist
     */
    func testGetRestaurantMenuWithRating1(){
        let exp = expectation(description: "testRestaurantMenuWithRating1")
        let r = Restaurant()
        r.google_link = "kfc_link"
        r.name = "kfc"
        r.getRestaurantMenuWithRating(){ result in
            switch result {
            case .success(_):
                XCTAssertTrue(r.menu[0].name == "Fried chicken")
                XCTAssertTrue(r.menu[0].rating[0].rating_text == "This chicken is so good")
                XCTAssertTrue(r.menu[0].rating[0].author == "test1")
                XCTAssert(true)
            case .failure(_):
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    /*
     * Try to pull the menu with rating of a non existing restaurant
     * Result: the api call should fail, and the status should return false
     * After: The server will create a new restaurant
     */
    func testGetRestaurantMenuWithRating2(){
        let exp = expectation(description: "testRestaurantMenuWithRating2")
        let r = Restaurant()
        r.google_link = "no_such_a_link"
        r.name = "no_such_a_restaurant"
        r.getRestaurantMenuWithRating(){result in
            switch result{
            case .success(_):
                XCTAssert(true)
            case .failure(_):
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    /*
     * Try to pull the menu with rating of a existing restaurant, but the google_link does not exist in our database
     * At this case, we would consider that there is another restaurant(with same name) that has this google_link
     * Result: So instead, we will create a new restaurant with provided restaurant name and google_link
     */
    func testGetRestaurantMenuWithRating3(){
        let exp = expectation(description: "testRestaurantMenuWithRating3")
        let r = Restaurant()
        r.google_link = "no_such_a_link1"
        // The name is valid, because we do have kfc in our database
        r.name = "kfc"
        r.getRestaurantMenuWithRating() { result in
            switch result{
            case .success(_):
                XCTAssert(true)
            case .failure(_):
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    /*
     * Try to pull the menu with rating of a existing restaurant with TRUE google_link, FALSE restaurant name
     * The result is actually the design choice, so we made it to return the restaurant of the corresponded google_link
     * Result: The function will return the menu with raing of kfc_link(kfc)
     */
    func testGetRestaurantMenuWithRating4(){
        let exp = expectation(description: "testRestaurantMenuWithRating4")
        let r = Restaurant()
        r.google_link = "kfc_link"
        r.name = "no_such_a_restaurant_3"
        r.getRestaurantMenuWithRating() { result in
            switch result{
            case .success(_):
                XCTAssertTrue(r.menu[0].name == "Fried chicken")
                XCTAssertTrue(r.menu[0].rating[0].rating_text == "This chicken is so good")
                XCTAssertTrue(r.menu[0].rating[0].author == "test1")
                XCTAssert(true)
            case .failure(_):
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    /*
     * Testing a real place with long google_link
     */
    func testGetRestaurantMenuWithRating5(){
        let exp = expectation(description: "testRestaurantMenuWithRating5")
        let r = Restaurant()
        r.name = "Hotel Fusion"
        r.google_link = "ChIJ0SMraI-AhYAREeJAvm2_yGM"
        r.getRestaurantMenuWithRating() { result in
            switch result{
            case .success(_):
                XCTAssert(true)
            case .failure(_):
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    /*
     * Testing a real place with google_link and wrong name
     */
    func testGetRestaurantMenuWithRating6(){
        let exp = expectation(description: "testRestaurantMenuWithRating6")
        let r = Restaurant()
        r.name = "kfc"
        r.google_link = "ChIJ0SMraI-AhYAREeJAvm2_yGM"
        r.getRestaurantMenuWithRating() { result in
            switch result{
            case .success(_):
                XCTAssertTrue(r.name == "Hotel Fusion")
                XCTAssert(true)
            case .failure(_):
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
}
