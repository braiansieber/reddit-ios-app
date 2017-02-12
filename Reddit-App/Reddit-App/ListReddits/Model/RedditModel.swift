//
//  RedditModel.swift
//  Reddit-App
//
//  Created by Marcelo Busico on 11/2/17.
//  Copyright © 2017 Busico. All rights reserved.
//

import Foundation

struct RedditModel {

  let title: String
  let author: String
  let commentsCount: Int
  let dateCreated: Date
  let thumbnailUrl: String

  init(title: String,
    author: String,
    commentsCount: Int,
    dateCreated: Date,
    thumbnailUrl: String) {

    self.title = title
    self.author = author
    self.commentsCount = commentsCount
    self.dateCreated = dateCreated
    self.thumbnailUrl = thumbnailUrl
  }
}
