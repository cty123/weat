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
        User.getUserInfo(profile_id: "1"){ user in
            user.deleteUser(){ status in
                print("success")
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
