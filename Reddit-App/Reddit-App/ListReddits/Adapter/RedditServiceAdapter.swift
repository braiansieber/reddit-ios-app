//
//  RedditServiceAdapter.swift
//  Reddit-App
//
//  Created by Marcelo Busico on 11/2/17.
//  Copyright © 2017 Busico. All rights reserved.
//

import Foundation

class RedditServiceAdapter: RedditServiceAdapterProtocol {

  func loadTopReddits(amount: Int, afterName: String?,
                      onComplete: (_ redditModel: [RedditModel]) -> Void,
                      onError: (_ error: Error) -> Void) {
    //TODO: To be implemented
  }
}
