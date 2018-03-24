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
     * id    name        email           phone       location          facebook_link    token       privacy     deleted     createdAt    updatedAt
     *  1    test1   test1@test1.com      test1      test1_location   test1_link       test1_token    0           0         dont care     dont care
     *  2    test2   test2@test2.com      test2      test2_location   test2_link       test2_token    1           0         dont care     dont care
     *  3    YOUR ACCOUNT
     *  4    test3   test3@test3.com      test3      test3_location   test3_link       test3_token    0           0         dont care     dont care
     * In "relationship" table, make sure you have
     * id   friendId    createdAt   updatedAt   accepted    userId
     *  x   1               x           x       1           FBSDK token id
     *  x   FBSDK token id  x           x       1           1
     *  x   FBSDK token id  x           x       0           4
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
    * This test should succeed and return a list of friends of the user
    */
    func testGetFriends1(){
        let exp = expectation(description: "testGetFriends1")
        Friend.getFriends(profile_id: UserDefaults.standard.string(forKey: "id")!){ result in
            switch result{
            case .success(let friends):
                if (friends[0].name == "test1"){
                    XCTAssert(true)
                }else{
                    XCTAssert(false)
                }
                exp.fulfill()
            case .failure(_):
                XCTAssert(false)
            }
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    /*
    * Test getting the friend of the user
    * This test should fail because the user is trying to pull some one else's friends
     * Result: getFirends call return false, the test cases shou be true
    */
    func testGetFriends2(){
        let exp = expectation(description: "testGetFriends2")
        Friend.getFriends(profile_id: "1"){ result in
            switch result{
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
     * Test getting the friend of the user
     * This test should fail because the user is trying pull non existing user's friends
     * Result: getFirends call return false, the test cases shou be true
     */
    func testGetFriends3(){
        let exp = expectation(description: "testGetFriends3")
        Friend.getFriends(profile_id: "1"){ result in
            switch result{
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
    * Test if a user can send friend request to others
    */
    func testSendFriendRequest(){
        let exp = expectation(description: "testSendFriendRequest")
        Friend.sendFriendRequest(friend_id: "2"){status in
            XCTAssert(status)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    /*
    * Test if the user can pull friend requests from others
    */
    func testPullFriendRequest(){
        let exp = expectation(description: "testPullFriendRequest")
        Friend.pullFriendRequest(){result in
            switch result{
            case .success(let requests):
                XCTAssert(requests[0].name == "test2")
            case .failure(_):
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    /*
    * Test if the user can accept a friend request
    */
    func testSetFriendRequests(){
        let exp = expectation(description: "testSetFriendRequests")
        Friend.setFriendRequest(friend_id: 4, acceptance: 1){ status in
            XCTAssert(status)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    /*
     * Test if the user can search a friend
     */
    func testSearchFriends(){
        let testGroup = DispatchGroup()
        var flag = false
        testGroup.enter()
        Friend.searchFriend(search_criteria: "test1", page: 10, limit: 20){ users in
            XCTAssert(users[0].name == "test1")
            flag = true
            testGroup.leave()
        }
        testGroup.notify(queue: .main){
            XCTAssert(flag)
        }
    }
    
    func testGetUserByFacebookLink(){
        let exp = expectation(description: "testGetUserByFacebookLink")
        Friend.getUserByFacebookLink(facebook_link: "test1_link"){ result in
            switch result{
                case .success(let user):
                    XCTAssert(user.name == "test1")
                case .failure(_):
                    XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
}
