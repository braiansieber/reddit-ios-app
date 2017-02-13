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

  func loadTopReddits(amount: Int, afterName: String?,
                      onComplete: (_ redditModel: [RedditModel]) -> Void,
                      onError: (_ error: Error) -> Void) {
    //TODO: To be implemented
  }
}
