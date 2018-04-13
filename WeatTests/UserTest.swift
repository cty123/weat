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
    * id    name        email           phone       location          facebook_link    token       privacy     deleted     createdAt    updatedAt
    *  1    test1   test1@test1.com      test1      test1_location   test1_link       test1_token    0           0         dont care     dont care
    *  2    test2   test2@test2.com      test2      test2_location   test2_link       test2_token    1           0         dont care     dont care
    */
    override func setUp() {
        super.setUp()
        // PutestGroup.leave setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /*
    * Testing /User/getUserInfo() function
    */
    func testGetUserInfo1(){
        let exp = expectation(description: "testGetUserInfo1")
        User.getUserInfo(profile_id: "1"){result in
            switch result {
                case .success(let user):
                    print("----- Start of testGetUserInfo1 -----")
                    let testUser1 = user
                        let id = testUser1.id
                        let name = testUser1.name
                        let email = testUser1.email
                        let phone = testUser1.phone
                        let location = testUser1.location
                        let privacy = testUser1.privacy
                        XCTAssert(id == 1)
                        XCTAssert(name == "test1")
                        XCTAssert(email == "test1@test1.com")
                        XCTAssert(phone == "test1")
                        XCTAssert(location == "test1_location")
                        // Because the get info return true, so the privacy must be 0
                        XCTAssert(privacy == 0)
                        print(id!)
                        print(name!)
                        print(email!)
                        print(phone!)
                        print(location!)
                        print(privacy!)
                    exp.fulfill()
                case .failure(_):
                    XCTAssert(false)
                    exp.fulfill()
                }
            }
        wait(for: [exp], timeout: 10.0)
    }
    
    /*
    * This function will pass no credential to the server, if successful, the returned user will contain all nil infomation
    * This one is supposed to enter .failure
    */
    func testGetUserInfo2(){
        let expectation = XCTestExpectation(description: "testGetUserInfo2")
        User.getUserInfo(profile_id: "23213"){result in
            switch result {
            case .success(_):
                XCTAssert(false)
                expectation.fulfill()
            case .failure(_):
                // The program should enter here
                XCTAssert(true)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    /*
     * This function will run normally, but the user it's pull has privacy set to 0 which means it does not want others to pull
     * the info. So this function should fail
     */
    func testGetUserInfo3(){
        let exp = expectation(description: "testGetUserInfo3")
        User.getUserInfo(profile_id: "2"){result in
            switch result {
            case .success(_):
                XCTAssert(false)
                exp.fulfill()
            case .failure(_):
                // The program should enter here
                XCTAssert(true)
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    /*
     * This function is used to test the update info function
     * After running this test the current user(FBSDK token bonded user)'s user name will be changed to "Testing"
     * Test: Update the email of current user to "test@test.com"
     * Result: Should enter .success, and pass all the assertions
     */
    /*
    func testUpdateUserInfo1(){
        let exp = expectation(description: "testUpdateUserInfo1")
        User.getUserInfo(profile_id: UserDefaults.standard.string(forKey: "id")!){ result in
            switch result{
            case .success(let user):
                user.email = "test@test.com"
                user.updateUserInfo(){status in
                    if status{
                        User.getUserInfo(profile_id: UserDefaults.standard.string(forKey: "id")!){ result in
                            switch result{
                            case .success(let u):
                                XCTAssert(u.email == "test@test.com")
                            case .failure(_):
                                XCTAssert(false)
                            }
                            exp.fulfill()
                        }
                    }else{
                        XCTAssert(false)
                    }
                }
            case .failure(_):
                XCTAssert(false)
            }
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    /*
     * Test: Try to update the user info for other random user, which is not allowed
     * 
     */
    func testUpdateUserinfo2(){
        let exp = expectation(description: "testUpdateUserInfo2")
        User.getUserInfo(profile_id: "1"){result in
            switch result{
            case .success(let user):
                // Here we try to be some malicious guy trying to mess up this user's profile
                user.updateUserInfo(){ r in
                    if (r){
                        // Should never enter here
                        XCTAssert(true)
                        exp.fulfill()
                    }else{
                        // Should enter here so the user's profile is secure
                        XCTAssert(false)
                        exp.fulfill()
                    }
                }
            case .failure(_):
                // Should not fail on getting user info
                XCTAssert(false)
            }
        }
        wait(for: [exp], timeout: 10.0)
    }
 */
}
 
