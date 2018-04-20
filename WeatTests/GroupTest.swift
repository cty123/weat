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
                    print(g)
                }
            case .failure(_):
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    // User stroy 1 --- Group creation
    func testCreate1() {
        let exp = expectation(description: "testCreate1")
        Group.create(group_name: "TestCreate1", icon_id: 2){ result in
            if result{
                XCTAssert(true)
            }else{
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    func testCreate2() {
        let exp = expectation(description: "testCreate2")
        Group.create(group_name: "TestCreate2", icon_id: 2){ result in
            if result{
                XCTAssert(true)
            }else{
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    // User story 2 --- Group invite
    func testInvite1(){
        let exp = expectation(description: "testInvite1")
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
    
    func testInvite2(){
        let exp = expectation(description: "testInvite2")
        Group.invite(group_id: 1, friend_ids: "1,3"){ result in
            if result {
                XCTAssert(true)
            }else{
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    // User story 3 --- Leave group
    func testLeave1() {
        let exp = expectation(description: "testLeave1")
        Group.leave(group_id: 1){result in
            if result{
                XCTAssert(true)
            }else{
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    func testLeave2() {
        let exp = expectation(description: "testLeave2")
        Group.leave(group_id: 1){result in
            if result{
                XCTAssert(true)
            }else{
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    // User story 4 --- Edit group
    func testEdit1(){
        let exp = expectation(description: "testEdit1")
        Group.edit(group_id: 1, group_name: "yoyoyo", group_icon_id: 6){ result in
            if result {
                Group.getAll(){ result in
                    switch result{
                    case .success(let groups):
                        XCTAssert(groups[0].name == "yoyoyo")
                        XCTAssert(groups[0].icon_id == 6)
                    case .failure(_):
                        XCTAssert(false)
                    }
                    exp.fulfill()
                }
                XCTAssert(true)
            }else{
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    func testEdit2(){
        let exp = expectation(description: "testEdit2")
        Group.edit(group_id: 1, group_name: "haha", group_icon_id: 1){ result in
            if result {
                Group.getAll(){ result in
                    switch result{
                    case .success(let groups):
                        XCTAssert(groups[0].name == "haha")
                        XCTAssert(groups[0].icon_id == 1)
                    case .failure(_):
                        XCTAssert(false)
                    }
                    exp.fulfill()
                }
                XCTAssert(true)
            }else{
                XCTAssert(false)
            }
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    // User story 5 --- Rejoin group
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
    
    // User story 6 --- Recommend
    func testRecommendation() {
        let exp = expectation(description: "testRecommendation")
        Group.getRecommendation(group_id: 1, latitude: 72, longitude: 27){ result in
            switch result {
            case .success(let restaurants):
            for i in restaurants {
                print(i)
            }
            XCTAssert(true)
            case .failure(let error):
                print(error)
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    // User story 7 --- Get members
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
    
    // User story 8 --- Remove friend
    func testRemoveFriend1() {
        let exp = expectation(description: "testRemoveFriend1")
        Friend.remove(id: "1") { result in
            switch result {
            case .success(_):
                XCTAssert(true)
            case .failure(let error):
                print(error)
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    func testRemoveFriend2() {
        let exp = expectation(description: "testRemoveFriend2")
        Friend.remove(id: "2") { result in
            switch result {
            case .success(_):
                XCTAssert(true)
            case .failure(_):
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    // Recommendation
    func testRecommendation1(){
        let exp = expectation(description: "testRecommendation1")
        Group.getRecommendation(group_id: 1, latitude: 40.427, longitude: -86.9196){ result in
            switch result{
            case .success(let restaurants):
                print(restaurants)
                XCTAssert(true)
            case .failure(let error):
                print(error)
                XCTAssert(false)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    // Extra
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
