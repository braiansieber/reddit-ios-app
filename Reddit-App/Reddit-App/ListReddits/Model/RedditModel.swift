//
//  RedditModel.swift
//  Reddit-App
//
//  Created by Marcelo Busico on 11/2/17.
//  Copyright © 2017 Busico. All rights reserved.
//

import Foundation

struct RedditModel {

  let name: String
  let title: String
  let author: String
  let commentsCount: Int
  let dateCreated: Date
  let thumbnailURL: URL?
  let imageURL: URL?

  init(name: String,
    title: String,
    author: String,
    commentsCount: Int,
    dateCreated: Date,
    thumbnailURL: URL?,
    imageURL: URL?) {

    self.name = name
    self.title = title
    self.author = author
    self.commentsCount = commentsCount
    self.dateCreated = dateCreated
    self.thumbnailURL = thumbnailURL
    self.imageURL = imageURL
  }
}
