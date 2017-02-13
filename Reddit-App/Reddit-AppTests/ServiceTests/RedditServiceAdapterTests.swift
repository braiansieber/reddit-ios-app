//
//  RedditServiceAdapterTests.swift
//  Reddit-AppTests
//
//  Created by Marcelo Busico on 11/2/17.
//  Copyright © 2017 Busico. All rights reserved.
//

import XCTest
@testable import Reddit_App

class RedditServiceAdapterTests: XCTestCase {

  var serviceAdapter: RedditServiceAdapterProtocol!

  override func setUp() {
    super.setUp()
    serviceAdapter = RedditServiceAdapter()
  }

  func testLoadTopReddits_withSpecificAmountWithoutAfterReddit_shouldLoadSpecificAmountOfReddits() {
    //Setup
    let amount = 10
    let afterName: String? = nil

    //Test
    let topReddits = serviceAdapter.loadTopReddits(amount: amount, afterName: afterName)

    //Verify
    XCTAssertEqual(amount, topReddits.count, "Unexpected amount of reddits returned.")
    for reddit in topReddits {
      XCTAssertFalse(reddit.name.isEmpty, "Reddit name should not be empty.")
      XCTAssertFalse(reddit.title.isEmpty, "Reddit title should not be empty.")
      XCTAssertFalse(reddit.author.isEmpty, "Reddit author should not be empty.")
      XCTAssertGreaterThan(0, reddit.commentsCount, "Reddit comments count should be a positive number.")
    }
  }

  func testLoadTopReddits_withAfterSpecificRedditName_shouldLoadRedditsAfterSpecifiedReddit() {
    //Setup
    let amount = 3
    let afterName: String? = nil

    //Test
    let topReddits = serviceAdapter.loadTopReddits(amount: amount, afterName: afterName)

    guard let lastReddit = topReddits.last else {
      XCTFail("Last reddit could not be determined.")
      return
    }

    let topRedditsAfterReddit = serviceAdapter.loadTopReddits(amount: amount, afterName: lastReddit.name)

    //Verify
    XCTAssertEqual(10, topRedditsAfterReddit.count, "Unexpected amount of reddits returned.")

    XCTAssertFalse(topRedditsAfterReddit.contains { (reddit) -> Bool in
      return reddit.name == lastReddit.name
    }, "Last reddit from previous query should not exist in new query after that reddit.")
  }
}
