//
//  RedditServiceAdapter.swift
//  Reddit-App
//
//  Created by Marcelo Busico on 11/2/17.
//  Copyright © 2017 Busico. All rights reserved.
//

import Foundation

class RedditServiceAdapter: RedditServiceAdapterProtocol {

  let redditBaseURL = "https://www.reddit.com/"
  let listTopReddits = "top.json"

  func loadTopReddits(amount: Int, afterName: String?,
                      onComplete: @escaping (_ redditModel: [RedditModel]) -> Void,
                      onError: @escaping (_ error: Error) -> Void) {

    let stringUrl = "\(redditBaseURL)\(listTopReddits)"

    guard var urlComponents = URLComponents(string: stringUrl) else {
      onError(RedditServiceError(message: "Invalid URL: \(stringUrl)"))
      return
    }

    var queryItems = [
      URLQueryItem(name: "limit", value: "\(amount)")
    ]

    if let afterName = afterName {
      queryItems.append(
        URLQueryItem(name: "after", value: afterName)
      )
    }

    urlComponents.queryItems = queryItems

    guard let url = urlComponents.url else {
      onError(RedditServiceError(message: "Invalid URL Component for query items: \(queryItems)"))
      return
    }

    let request = URLRequest(url: url)

    URLSession.shared.dataTask(with: request) { (data, response, error) in
      if let error = error {
        onError(error)
        return
      }

      guard let data = data else {
        onError(RedditServiceError(message: "Service response without data."))
        return
      }

      do {
        guard let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: AnyObject] else {
          onError(RedditServiceError(message: "Unexpected response data."))
          return
        }

        let redditsList = self.mapRedditModelList(jsonDictionary: jsonResponse)
        onComplete(redditsList)
      } catch let error {
        onError(error)
      }
    }.resume()
  }

  private func mapRedditModelList(jsonDictionary: [String: AnyObject]) -> [RedditModel] {
    var redditsList = [RedditModel]()
    //TODO: To be implemented

    guard let dataDictionary = jsonDictionary["data"] as? [String: AnyObject] else {
      return redditsList
    }

    guard let childrenArray = dataDictionary["children"] as? [AnyObject] else {
      return redditsList
    }

    for redditObject in childrenArray {
      guard let redditDictionary = redditObject["data"] as? [String: AnyObject] else {
        continue
      }

      guard let redditModel = redditModel(withDictionary: redditDictionary) else {
        continue
      }

      redditsList.append(redditModel)
    }
    return redditsList
  }

  private func redditModel(withDictionary redditDictionary: [String: AnyObject]) -> RedditModel? {
    guard let name = redditDictionary["name"] as? String else {
      return nil
    }

    guard let title = redditDictionary["title"] as? String else {
      return nil
    }

    guard let author = redditDictionary["author"] as? String else {
      return nil
    }

    guard let commentsCount = redditDictionary["num_comments"] as? Int else {
      return nil
    }

    guard let createdUtcTime = redditDictionary["created_utc"] as? TimeInterval else {
      return nil
    }

    let dateCreated = Date(timeIntervalSince1970: createdUtcTime)

    var thumbnailURL: URL? = nil
    var imageURL: URL? = nil


    if let thumbnailUrlString = redditDictionary["thumbnail"] as? String {
      thumbnailURL = URL(string: thumbnailUrlString)
    }

    if let imageUrlString = redditDictionary["url"] as? String {
      imageURL = URL(string: imageUrlString)
    }

    return RedditModel(
      name: name,
      title: title,
      author: author,
      commentsCount: commentsCount,
      dateCreated: dateCreated,
      thumbnailURL: thumbnailURL,
      imageURL: imageURL
    )
  }
}
