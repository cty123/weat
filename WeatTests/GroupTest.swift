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
            case .success(let groups):
                for g in groups{
                    
                }
                exp.fulfill()
            case .failure(_):
                XCTAssert(false)
            }
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    func testCreate() {
        let exp = expectation(description: "testCreate")
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
    
    func testLeave() {
        let exp = expectation(description: "testLeave")
        Group.leave(group_id: 1){result in
            if result{
                XCTAssert(true)
                exp.fulfill()
            }else{
                XCTAssert(false)
            }
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    func testEdit(){
        let exp = expectation(description: "testEdit")
        Group.edit(group_id: 1, group_name: "yoyoyo", group_icon_id: 666){ result in
            if result {
                XCTAssert(true)
            }else{
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    func testGetLeft(){
        let exp = expectation(description: "testGetLeft")
        Group.getLeft(){ result in
            switch result{
            case .success(let groups):
                print(groups)
                exp.fulfill()
            case .failure(_):
                XCTAssert(false)
            }
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    func testRejoin(){
        let exp = expectation(description: "testRejoin")
        Group.rejoin(group_id: 1){ result in
            if result {
                XCTAssert(true)
            }else{
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    func testInvite(){
        let exp = expectation(description: "testInvite")
        Group.invite(group_id: 1, friend_ids: "1,"){ result in
            if result {
                XCTAssert(true)
            }else{
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    func testGetMembers(){
        let exp = expectation(description: "testGetMembers")
        Group.getMembers(group_id: 1){ result in
            switch result{
            case .success(let users):
                print(users)
            case .failure(_):
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    func testKick(){
        let exp = expectation(description: "testKick")
        Group.kick(user_id: 1, group_id: 1){ result in
            if result {
                Group.getMembers(group_id: 1){ result in
                    switch result{
                    case .success(let users):
                        XCTAssert(users.count==1)
                    case .failure(_):
                        XCTAssert(false)
                    }
                    exp.fulfill()
                }
            }else{
                XCTAssert(false)
            }
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    func testDestroy(){
        let exp = expectation(description: "testDestroy")
        Group.destroy(group_id: 1){ result in
            if result {
                XCTAssert(true)
                exp.fulfill()
            }else{
                XCTAssert(false)
            }
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    
}
