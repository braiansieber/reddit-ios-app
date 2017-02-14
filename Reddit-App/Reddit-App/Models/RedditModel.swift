//
//  RedditModel.swift
//  Reddit-App
//
//  Created by Marcelo Busico on 11/2/17.
//  Copyright © 2017 Busico. All rights reserved.
//

import Foundation

class RedditModel: NSObject, NSCoding {

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

  // MARK: - NSCoding
  required init?(coder: NSCoder) {
    self.name = coder.decodeString(name: "name")
    self.title = coder.decodeString(name: "title")
    self.author = coder.decodeString(name: "author")
    self.commentsCount = coder.decodeInteger(forKey: "commentsCount")
    self.dateCreated = Date(timeIntervalSince1970: coder.decodeDouble(forKey: "dateCreated"))
    self.thumbnailURL = coder.decodeURL(name: "thumbnailURL")
    self.imageURL = coder.decodeURL(name: "imageURL")
  }

  func encode(with coder: NSCoder) {
    coder.encode(self.name, forKey: "name")
    coder.encode(self.title, forKey: "title")
    coder.encode(self.author, forKey: "author")
    coder.encode(self.commentsCount, forKey: "commentsCount")
    coder.encode(self.dateCreated.timeIntervalSince1970, forKey: "dateCreated")
    coder.encode(self.thumbnailURL?.absoluteString, forKey: "thumbnailURL")
    coder.encode(self.imageURL?.absoluteString, forKey: "imageURL")
  }

  // MARK: - Internal Methods
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
