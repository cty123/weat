//
//  RecommendationTest.swift
//  WeatTests
//
//  Created by ctydw on 3/24/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import Foundation
import XCTest
@testable import Weat

public class RecommendationTest: XCTestCase {
    
    /*
     * Pull a recommendation
     */
    func testGetRecommendation1(){
        let exp = expectation(description: "testGetRecommendation1")
        User.getUserInfo(profile_id: "3"){result in
            switch result {
            case .success(let user):
                // Get the first(only) recommendation of the user
                let r = user.recommendations[0]
                XCTAssert(r.friend_name == "test1")
                XCTAssert(r.friend_id == 1)
            case .failure(_):
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    /*
     * Pull another recommendation
     */
    func testGetRecommendation2(){
        let exp = expectation(description: "testGetRecommendation2")
        User.getUserInfo(profile_id: "3"){result in
            switch result {
            case .success(let user):
                // Get the first(only) recommendation of the user
                let r = user.recommendations[1]
                XCTAssert(r.restaurant_name == "Hotel Fusion")
            case .failure(_):
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    /*
     * Check if the pull recommendation function can pull duplcate recommendations
     * Recommendation 1 and 3 are duplicated recommendations that are sent twice by the sender
     */
    func testGetRecommendation3(){
        let exp = expectation(description: "testGetRecommendation2")
        User.getUserInfo(profile_id: "3"){result in
            switch result {
            case .success(let user):
                // Get the first(only) recommendation of the user
                let r = user.recommendations[2]
                XCTAssert(r.restaurant_name == "kfc")
                let r1 = user.recommendations[0]
                XCTAssert(r1.restaurant_name == "kfc")
            case .failure(_):
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    /*
     * Try to pull recommendation from other users who does not allow others to see his/her info
     * Request should be denied
     */
    func testGetRecommendation4(){
        let exp = expectation(description: "testGetRecommendation4")
        User.getUserInfo(profile_id: "2"){result in
            switch result {
            case .success(_):
                XCTAssert(false)
            case .failure(_):
                XCTAssert(true)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    /*
     * Try to pull a Recommendation sent from the same user about the same restaurant but with different menu_item
     */
    func testGetRecommendation5(){
        let exp = expectation(description: "testGetRecommendation5")
        User.getUserInfo(profile_id: "3"){result in
            switch result {
            case .success(let user):
                // Get the first(only) recommendation of the user
                let r = user.recommendations[3]
                XCTAssert(r.recommended_menu_item_name == "McNuggets")
                XCTAssert(r.recommended_menu_item_id == 2)
            case .failure(_):
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    /*
     * Try to pull recommendation of other user who set privacy to be allowing others to view his/her info
     */
    func testGetRecommendation6(){
        let exp = expectation(description: "testGetRecommendation6")
        User.getUserInfo(profile_id: "1"){result in
            switch result {
            case .success(let user):
                // Get the first(only) recommendation of the user
                let r = user.recommendations[0]
                XCTAssert(r.recommended_menu_item_name == "McNuggets")
                XCTAssert(r.recommended_menu_item_id == 2)
            case .failure(_):
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    /*
     * Try to send recommendation to a single user
     * This should succeed
     * The restaurant is valid and the menu_item is also valid
     * Result: Request should succeed and pass the test case
     */
    func testPostRecommendation1(){
        let exp = expectation(description: "testGetRecommendation1")
        Recommendation.sendRecommendation(google_link: "kfc_link", menu_item_id: 1, restaurant_name: "kfc", friend_ids: "1"){status in
            if status {
                XCTAssert(true)
            }else {
                // This request should not fail
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    /*
     * Try to send recommendation to a multiple users
     * This should succeed
     * The restaurant is valid and the menu_item is also valid
     * Result: Request should succeed and pass the test case
     */
    func testPostRecommendation2(){
        let exp = expectation(description: "testGetRecommendation1")
        Recommendation.sendRecommendation(google_link: "kfc_link", menu_item_id: 1, restaurant_name: "kfc", friend_ids: "1,2"){status in
            if status {
                XCTAssert(true)
            }else {
                // This request should not fail
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    /*
     * Try to send recommendation to a single user
     * This should succeed
     * The restaurant does not exist, and the menu_item exists
     * Result: The server will automatically create a new restaurant in database, and return true to client
     */
    func testPostRecommendation3(){
        let exp = expectation(description: "testGetRecommendation3")
        Recommendation.sendRecommendation(google_link: "Rec3_test", menu_item_id: 1, restaurant_name: "Rec3_test_restaurant", friend_ids: "1"){status in
            if status {
                XCTAssert(true)
            }else {
                // This request should not fail
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    /*
     * Try to send recommendation to multiple users
     * This should succeed
     * The restaurant does not exist, and the menu_item exists
     * Result: The server will automatically create a new restaurant in database, and return true to client
     */
    func testPostRecommendation4(){
        let exp = expectation(description: "testGetRecommendation4")
        Recommendation.sendRecommendation(google_link: "Rec4_test", menu_item_id: 1, restaurant_name: "Rec4_test_restaurant", friend_ids: "1,2"){status in
            if status {
                XCTAssert(true)
            }else {
                // This request should not fail
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    /*
     * Try to send a recommendation about a restaurant to a single user for 3times
     * This request should succeed
     * The restaurant and menu_item both exist
     * Result: The server will send the same recommendations 3 times and create 3 records. And the receiver should have 3 records
     */
    func testPostRecommendation5(){
        let exp = expectation(description: "testGetRecommendation5")
        Recommendation.sendRecommendation(google_link: "kfc_link", menu_item_id: 1, restaurant_name: "kfc", friend_ids: "1"){s1 in
            if s1 {
                Recommendation.sendRecommendation(google_link: "kfc_link", menu_item_id: 1, restaurant_name: "kfc", friend_ids: "1"){s2 in
                    if s2 {
                        Recommendation.sendRecommendation(google_link: "kfc_link", menu_item_id: 1, restaurant_name: "kfc", friend_ids: "1"){s3 in
                            if s3 {
                                XCTAssert(true)
                            }else{
                                XCTAssert(false)
                            }
                            exp.fulfill()
                        }
                    }else{
                        XCTAssert(false)
                    }
                }
            }else {
                // This request should not fail
                XCTAssert(false)
            }
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    /*
     * Try to send a recommendation about a restaurant to multiple users for 3 times
     * This request should succeed
     * The restaurant and menu_item both exist
     * Result: The server will send the same recommendations 3 times and create 3 records. And the receiver should have 3 records
     */
    func testPostRecommendation6(){
        let exp = expectation(description: "testGetRecommendation5")
        Recommendation.sendRecommendation(google_link: "kfc_link", menu_item_id: 1, restaurant_name: "kfc", friend_ids: "1,2"){s1 in
            if s1 {
                Recommendation.sendRecommendation(google_link: "kfc_link", menu_item_id: 1, restaurant_name: "kfc", friend_ids: "1,2"){s2 in
                    if s2 {
                        Recommendation.sendRecommendation(google_link: "kfc_link", menu_item_id: 1, restaurant_name: "kfc", friend_ids: "1,2"){s3 in
                            if s3 {
                                XCTAssert(true)
                            }else{
                                XCTAssert(false)
                            }
                            exp.fulfill()
                        }
                    }else{
                        XCTAssert(false)
                    }
                }
            }else {
                // This request should not fail
                XCTAssert(false)
            }
        }
        wait(for: [exp], timeout: 10.0)
    }
}
