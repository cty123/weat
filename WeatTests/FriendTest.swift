//
//  FriendTest.swift
//  WeatTests
//
//  Created by ctydw on 3/18/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import Foundation
import XCTest
@testable import Weat

class FriendTest: XCTestCase {
    // IMPORTANT INFORMATION !!!
    // READ DOCUMENTS BELOW BEFORE RUNNING THIS TEST !!!
    /*
     * Initialize settings, make sure that the database contains the following records
     * Make sure you have the following record in your database !!! Otherwise this test WILL NOT work
     * In "users" table, make sure you have
     * id    name        email           phone       location    facebook_link   token       privacy     deleted     createdAt    updatedAt
     *  x    testUser   test@test.com    1234567899  Purdue      test_link       test_token    0           0         dont care     dont care
     *  x    test2   test2@test2.com    1234567899  Purdue   test2_link      test2_token   0           0         dont care     dont care
     *  x    test3   test3@test3.com    1234567899  Purdue   test3_link      test3_token   0           0         dont care     dont care
     * In "relationship" table, make sure you have
     * id   friendId    createdAt   updatedAt   accepted    userId
     *  x   2               x           x       1           FBSDK token id
     *  x   FBSDK token id  x           x       1           2
     */
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /*
    * Test getting the friend of the user
    */
    func testGetFriends(){
        let testGroup = DispatchGroup()
        var flag = false
        testGroup.enter()
        Friend.getFriends(profile_id: UserDefaults.standard.string(forKey: "id")!){ friends in
            XCTAssertTrue(friends[0].name == "test2")
            flag = true
            testGroup.leave()
        }
        testGroup.notify(queue: .main){
            XCTAssertTrue(flag)
        }
    }
    
    /*
    * Test if a user can send friend request to others
    */
    func testSendFriendRequest(){
        let testGroup = DispatchGroup()
        var flag = false
        testGroup.enter()
        Friend.sendFriendRequest(friend_id: "1"){status in
            XCTAssertTrue(status)
            flag = true
            testGroup.leave()
        }
        testGroup.notify(queue: .main){
            XCTAssertTrue(flag)
        }
    }
    
    /*
    * Test if the user can pull friend requests from others
    */
    func testPullFriendRequest(){
        let testGroup = DispatchGroup()
        var flag = false
        testGroup.enter()
        Friend.pullFriendRequest(){requests in
            XCTAssertTrue(requests[0].name == "test3")
            flag = true
            testGroup.leave()
        }
        testGroup.notify(queue: .main){
            XCTAssertTrue(flag)
        }
    }
    
    /*
    * Test if the user can accept a friend request
    */
    func testSetFriendRequests(){
        let testGroup = DispatchGroup()
        var flag = false
        testGroup.enter()
        Friend.setFriendRequest(friend_id: 4, acceptance: 1){ status in
            XCTAssertTrue(status)
            flag = true
            testGroup.leave()
        }
        testGroup.notify(queue: .main){
            XCTAssertTrue(flag)
        }
    }
    
    /*
     * Test if the user can search a friend
     */
    func testSearchFriends(){
        let testGroup = DispatchGroup()
        var flag = false
        testGroup.enter()
        Friend.searchFriend(search_criteria: "testUser", page: nil, limit: nil){ users in
            XCTAssertTrue(users[0].name == "testUser")
            flag = true
            testGroup.leave()
        }
        testGroup.notify(queue: .main){
            XCTAssertTrue(flag)
        }
    }
    
}
