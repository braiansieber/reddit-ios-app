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

  func formattedTimeSinceSubmissions() -> String {
    let currentDate = Date()
    let timeInterval = currentDate.timeIntervalSince(dateCreated)

    if timeInterval < 60 {
      return "just now"
    }

    let minutes = Int(timeInterval / 60)
    if minutes < 60 {
      if minutes == 1 {
        return "a minute ago"
      } else {
        return "\(minutes) minutes ago"
      }
    }

    let hours = Int(minutes / 60)
    if hours < 24 {
      if hours == 1 {
        return "an hour ago"
      } else {
        return "\(hours) hours ago"
      }
    }
    
    let days = Int(hours / 24)
    if days == 1 {
      return "a day ago"
    } else {
      return "\(days) days ago"
    }
  }
}
