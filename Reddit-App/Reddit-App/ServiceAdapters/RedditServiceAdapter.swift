//
//  RedditServiceAdapter.swift
//  Reddit-App
//
//  Created by Marcelo Busico on 11/2/17.
//  Copyright © 2017 Busico. All rights reserved.
//

import UIKit

class RedditServiceAdapter: RedditServiceAdapterProtocol {

  // MARK: - Constants
  private let redditBaseURL = "https://www.reddit.com/"
  private let listTopReddits = "top.json"
  private let supportedURLsExtensions = [".jpg", ".jpeg", ".png"]

  // MARK: - Internal Methods
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

  func downloadImage(withURL url: URL,
                     onComplete: @escaping (UIImage) -> Void,
                     onError: @escaping (Error) -> Void) {

    URLSession.shared.dataTask(with: url) { (data, response, error) in
      if let error = error {
        onError(error)
        return
      }

      guard let data = data else {
        onError(RedditServiceError(message: "Unexpected response data."))
        return
      }

      if let image = UIImage(data: data) {
        onComplete(image)
      } else {
        onError(RedditServiceError(message: "Unsupported image format."))
      }
    }.resume()
  }

  // MARK: - Private Methods
  private func mapRedditModelList(jsonDictionary: [String: AnyObject]) -> [RedditModel] {
    var redditsList = [RedditModel]()

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
      //Filter: Only allow reddit URLs for images.
      if supportedURLsExtensions.contains(where: { (urlExtension) -> Bool in
        return imageUrlString.lowercased().hasSuffix(urlExtension)
      }) {
        imageURL = URL(string: imageUrlString)
      }
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
