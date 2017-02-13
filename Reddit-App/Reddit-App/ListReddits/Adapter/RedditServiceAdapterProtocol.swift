//
//  RedditServiceAdapterProtocol.swift
//  Reddit-App
//
//  Created by Marcelo Busico on 11/2/17.
//  Copyright © 2017 Busico. All rights reserved.
//

import Foundation

protocol RedditServiceAdapterProtocol {

  /**
   Load top reddits from server.

   - parameter amount: Reddits ammount to be retrieved (maximum: 100).
   
   - parameter afterName: Retrieve reddits after this name.
   
   - returns: List of reddits.
  */
  func loadTopReddits(amount: Int, afterName: String?) -> [RedditModel]
}
