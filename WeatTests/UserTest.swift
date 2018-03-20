//
//  UserTest.swift
//  WeatTests
//
//  Created by ctydw on 3/17/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import Foundation
import XCTest
@testable import Weat

class UserTest: XCTestCase {
    // IMPORTANT INFORMATION !!!
    // READ DOCUMENTS BELOW BEFORE RUNNING THIS TEST !!!
    /*
    * Initialize settings, make sure that the database contains the following records
    * Make sure you have the following record in your database !!! Otherwise this test WILL NOT work
    * In "users" table, make sure you have
    * id    name        email           phone       location    facebook_link   token       privacy     deleted     createdAt    updatedAt
    *  1    testUser   test@test.com    1234567899  Purdue      test_link       test_token    0           0         dont care     dont care
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
    * Testing /User/getUserInfo() function
    */
    func testGetUserInfo1(){
        var testUser1 = User()
        let testGroup = DispatchGroup()
        testGroup.enter()
            var flag = false
            User.getUserInfo(profile_id: "1"){result in
                switch result {
                    case .success(let user):
                        print("----- Start of testGetUserInfo1 -----")
                        testUser1 = user
                        let id = testUser1.id
                        let name = testUser1.name
                        let email = testUser1.email
                        let phone = testUser1.phone
                        let location = testUser1.location
                        let privacy = testUser1.privacy
                        XCTAssertTrue(id == 1)
                        XCTAssertTrue(name == "testUser")
                        XCTAssertTrue(email == "test@test.com")
                        XCTAssertTrue(phone == "1234567899")
                        XCTAssertTrue(location == "Purdue")
                        XCTAssertTrue(privacy == 0)
                        print(id!)
                        print(name!)
                        print(email!)
                        print(phone!)
                        print(location!)
                        print(privacy!)
                        flag = true
                    case .failure(_):
                        XCTAssertTrue(false)
                }
                testGroup.leave()
            }
        testGroup.notify(queue: .main){
            XCTAssertTrue(flag)
            print("----- End of testGetUserInfo1 -----")
        }
    }
    
    /*
    * This function will pass no credential to the server, if successful, the returned user will contain all nil infomation
    * This one is supposed to enter .failure
    */
    func testGetUserInfo2(){
        User.getUserInfo(profile_id: "21312"){result in
            switch result {
            case .success(_):
                XCTAssertTrue(false)
            case .failure(_):
                XCTAssertTrue(true)
            }
        }
    }
    
    /*
    * This function is used to test the update info function
    * After running this test the current user(FBSDK token bonded user)'s user name will be changed to "Testing"
    * Because a user can't update info for other users
    */
    func testUpdateUserInfo(){
        let testGroup = DispatchGroup()
        testGroup.enter()
        var flag = false
        User.getUserInfo(profile_id: UserDefaults.standard.string(forKey: "id")!){ result in
            switch result{
            case .success(let user):
                user.email = "test@test.com"
                user.updateUserInfo(){status in
                    if status{
                        User.getUserInfo(profile_id: UserDefaults.standard.string(forKey: "id")!){ result in
                            switch result{
                            case .success(let u):
                                assert(u.email == "test@test.com")
                                flag = true
                                testGroup.leave()
                            case .failure(_):
                                XCTAssertTrue(false)
                            }
                        }
                    }
                }
            case .failure(_):
                XCTAssertTrue(false)
            }
        }
        testGroup.notify(queue: .main){
            XCTAssertTrue(flag)
            print("----- End of testGetUserInfo1 -----")
        }
    }
    
    
}
