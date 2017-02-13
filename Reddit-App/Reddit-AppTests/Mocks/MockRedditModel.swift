//
//  MockRedditModel.swift
//  Reddit-App
//
//  Created by Marcelo Busico on 13/2/17.
//  Copyright © 2017 Busico. All rights reserved.
//

import Foundation
@testable import Reddit_App

class MockRedditModel {

  static func mock(name: String) -> RedditModel {
    return RedditModel(
      name: name,
      title: "mockTitle",
      author: "mockAuthor",
      commentsCount: 123,
      dateCreated: Date(),
      thumbnailURL: nil,
      imageURL: nil
    )
  }
}
