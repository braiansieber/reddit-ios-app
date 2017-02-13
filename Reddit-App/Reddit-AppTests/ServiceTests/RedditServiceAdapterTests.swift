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
  let expectationTimeOut: TimeInterval = 10

  override func setUp() {
    super.setUp()
    serviceAdapter = RedditServiceAdapter()
  }

  func testLoadTopReddits_withSpecificAmountWithoutAfterReddit_shouldLoadSpecificAmountOfReddits() {
    //Setup
    let amount = 10
    let afterName: String? = nil
    let loadTopRedditsExpectation = expectation(description: "loadTopRedditsExpectation")

    //Test
    serviceAdapter.loadTopReddits(amount: amount, afterName: afterName,
      onComplete: { topReddits in
        //Verify
        XCTAssertEqual(amount, topReddits.count, "Unexpected amount of reddits returned.")
        for reddit in topReddits {
          XCTAssertFalse(reddit.name.isEmpty, "Reddit name should not be empty.")
          XCTAssertFalse(reddit.title.isEmpty, "Reddit title should not be empty.")
          XCTAssertFalse(reddit.author.isEmpty, "Reddit author should not be empty.")
          XCTAssertGreaterThanOrEqual(reddit.commentsCount, 0, "Reddit comments count should be a positive number.")
        }
        loadTopRedditsExpectation.fulfill()
      },
      onError: { error in
        XCTFail("Error while loading topReddits: \(error).")
        loadTopRedditsExpectation.fulfill()
      }
    )

    waitForExpectations(timeout: expectationTimeOut, handler: nil)
  }

  func testLoadTopReddits_withAfterSpecificRedditName_shouldLoadRedditsAfterSpecifiedReddit() {
    //Setup
    let amount = 3
    let afterName: String? = nil
    let loadTopRedditsExpectation = expectation(description: "loadTopRedditsExpectation")

    //Test
    serviceAdapter.loadTopReddits(amount: amount, afterName: afterName,
      onComplete: { topReddits in
        guard let lastReddit = topReddits.last else {
          XCTFail("Last reddit could not be determined.")
          loadTopRedditsExpectation.fulfill()
          return
        }

        self.serviceAdapter.loadTopReddits(amount: amount, afterName: lastReddit.name,
          onComplete: { topRedditsAfterReddit in
            //Verify
            XCTAssertEqual(amount, topRedditsAfterReddit.count, "Unexpected amount of reddits returned.")

            XCTAssertFalse(topRedditsAfterReddit.contains { (reddit) -> Bool in
              return reddit.name == lastReddit.name
            }, "Last reddit from previous query should not exist in new query after that reddit.")
            loadTopRedditsExpectation.fulfill()
          },
          onError: { error in
            XCTFail("Error while loading topRedditsAfterReddit: \(error).")
            loadTopRedditsExpectation.fulfill()
          }
        )
      },
      onError: { error in
        XCTFail("Error while loading topReddits: \(error).")
        loadTopRedditsExpectation.fulfill()
      }
    )

    waitForExpectations(timeout: expectationTimeOut, handler: nil)
  }
}
