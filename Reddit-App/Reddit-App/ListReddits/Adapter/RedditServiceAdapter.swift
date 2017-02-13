//
//  RedditServiceAdapter.swift
//  Reddit-App
//
//  Created by Marcelo Busico on 11/2/17.
//  Copyright © 2017 Busico. All rights reserved.
//

import Foundation

class RedditServiceAdapter: RedditServiceAdapterProtocol {

  struct RedditServiceError: Error {
    let message: String

    init(message: String) {
      self.message = message
    }

    var localizedDescription: String {
      return "Reddit Service Error: '\(message)'"
    }
  }

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
    print(request)

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

        let redditsList = self.mapRedditModelList(jsonObject: jsonResponse)
        onComplete(redditsList)
      } catch let error {
        onError(error)
      }
    }.resume()
  }

  private func mapRedditModelList(jsonObject: [String: AnyObject]) -> [RedditModel] {
    var redditsList = [RedditModel]()
    //TODO: To be implemented
    return redditsList
  }
}
