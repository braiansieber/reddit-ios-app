//
//  RedditServiceError.swift
//  Reddit-App
//
//  Created by Marcelo Busico on 13/2/17.
//  Copyright © 2017 Busico. All rights reserved.
//

import Foundation

struct RedditServiceError: Error {
  let message: String

  init(message: String) {
    self.message = message
  }

  var localizedDescription: String {
    return "Reddit Service Error: '\(message)'"
  }
}
