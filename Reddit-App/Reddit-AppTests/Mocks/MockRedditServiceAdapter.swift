//
//  MockRedditServiceAdapter.swift
//  Reddit-AppTests
//
//  Created by Marcelo Busico on 11/2/17.
//  Copyright © 2017 Busico. All rights reserved.
//

import Foundation
@testable import Reddit_App

class MockRedditServiceAdapter: RedditServiceAdapterProtocol {

  var redditsList: [RedditModel]?
  var numberOfLoadCalls = 0

  func loadTopReddits(amount: Int, afterName: String?,
                      onComplete: @escaping (_ redditModel: [RedditModel]) -> Void,
                      onError: @escaping (_ error: Error) -> Void) {

    numberOfLoadCalls += 1

    if let redditsList = redditsList {
      onComplete(redditsList)
    } else {
      onError(RedditServiceError(message: "Mocked error."))
    }
  }
}
