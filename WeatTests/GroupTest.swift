//
//  GroupTest.swift
//  WeatTests
//
//  Created by ctydw on 4/4/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import Foundation
import XCTest
@testable import Weat

public class GroupTest: XCTestCase {
    func testGetALL() {
        let exp = expectation(description: "testGetALL")
        Group.getAll(){ result in
            switch result{
            case .success(_):
                exp.fulfill()
            case .failure(_):
                XCTAssert(false)
            }
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    func testCreate() {
        let exp = expectation(description: "testGetALL")
        Group.create(group_name: "hohoho", icon_id: 2){ result in
            if result{
                XCTAssert(true)
            }else{
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
}
