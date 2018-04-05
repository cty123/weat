//
//  FeedTest.swift
//  WeatTests
//
//  Created by ctydw on 3/25/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import Foundation
import XCTest
@testable import Weat

public class FeedTest: XCTestCase {
    
    /*
     * Testing data base
     -------------------------relationships--------------------------
     id    friendId    createdAt    updatedAt    accepted    userId
     1    3    2018-01-01 00:00:00    2018-01-01 00:00:00    1    1
     2    1    2018-01-01 00:00:00    2018-01-01 00:00:00    1    3
     3    3    2018-03-25 18:26:27    2018-03-27 03:06:05    0    2
     ----------------------------feeds-------------------------------
     id    user_id    restaurant_id    friend_id    archived    feed_text    menu_item_id    createdAt    updatedAt
     1    3    1    1    1    was recommended    1    2018-01-01 00:00:00    2018-01-01 00:00:00
     */
    
    func testFeedRecommendation(){
        let exp = expectation(description: "testFeedRecommendation")
        Feed.getFeed(feed_type: ""){ feed in
            XCTAssert(feed.data[0].feed_text == "was recommended")
            XCTAssert(feed.data[0].restaurant_name == "kfc")
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    func testFriendRequest(){
        let exp = expectation(description: "testFriendRequest")
        Friend.setFriendRequest(friend_id: 2, acceptance: 1){status in
            Feed.getFeed(feed_type: ""){ feed in
                XCTAssert(feed.data[0].feed_text == "made friends")
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    func testOthersFeed(){
        let exp = expectation(description: "testOthersFeed")
        Feed.getFeed(feed_type: "/friends"){ feed in
            XCTAssert(feed.data[0].feed_text == "made friends")
            XCTAssert(feed.data[1].feed_text == "made friends")
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
    /*
    func testPostRating(){
        let exp = expectation(description: "testPostRating")
        Rating.postRestaurantRating(google_link: "kfc_link", restaurant_name: "kfc", food_rating: 1, service_rating: 1, rating_text: "testing"){ status in
            Feed.getFeed(feed_type: ""){ feed in
                XCTAssert(feed.data[0].feed_text == "liked the food and service")
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    func testPostMenuRating(){
        let exp = expectation(description: "testPostMenuRating")
        Rating.postMenuItemRating(google_link: "kfc_link", restaurant_name: "kfc", menu_item_id: 1, food_rating: 1, rating_text: "test1"){ status in
            Feed.getFeed(feed_type: ""){ feed in
                XCTAssert(feed.data[0].feed_text == "liked the food")
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    func testFavoriteFeed(){
        let exp = expectation(description: "testPostRating")
        Favorite.addFavoriteRestaurant(google_link: "kfc_link", restaurant_name: "kfc"){status in
            Feed.getFeed(feed_type: ""){ feed in
                XCTAssert(feed.data[0].feed_text == "added favorite")
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 10.0)
    }
 */
}
