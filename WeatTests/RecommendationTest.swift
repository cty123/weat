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
    
    func testGetRecommendation2(){
        
    }
    
    func testGetRecommendation3(){
        
    }
    
    func testGetRecommendation4(){
        
    }
    
    func testGetRecommendation5(){
        
    }
    
    func testGetRecommendation6(){
        
    }
    
    /*
     *
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
    
    func testPostRecommendation2(){
        
    }
    
    func testPostRecommendation3(){
        
    }
    func testPostRecommendation4(){
        
    }
    func testPostRecommendation5(){
        
    }
    func testPostRecommendation6(){
        
    }
}
