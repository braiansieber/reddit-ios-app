//
//  ListRedditsPresenter.swift
//  Reddit-App
//
//  Created by Marcelo Busico on 13/2/17.
//  Copyright © 2017 Busico. All rights reserved.
//

import UIKit

class ListRedditsPresenter {

  // MARK: - Constants
  private let pageSize = 50

  // MARK: - Properties
  private weak var view: ListRedditsViewProtocol?
  private let serviceAdapter: RedditServiceAdapterProtocol
  private var redditsList = [RedditModel]()

  // MARK: - Initialization
  init(view: ListRedditsViewProtocol, serviceAdapter: RedditServiceAdapterProtocol) {
    self.view = view
    self.serviceAdapter = serviceAdapter
  }

  // MARK: - Internal Methods
  func start() {
    redditsList = [RedditModel]()
    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
      self.loadMoreReddits()
    }
  }

  func numberOfElements() -> Int {
    return redditsList.count
  }

  func elementModel(forPosition position: Int) -> RedditModel? {
    if position >= redditsList.count {
      return nil
    }

    if position == (redditsList.count - 1) {
      DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
        self.loadMoreReddits()
      }
    }

    return redditsList[position]
  }

  func loadThumbnailForModel(model: RedditModel,
                             onComplete: @escaping (UIImage?) -> Void) {

    guard let thumbnailURL = model.thumbnailURL else {
      onComplete(nil)
      return
    }

    DispatchQueue.global().async {
      self.serviceAdapter.downloadImage(withURL: thumbnailURL,
        onComplete: { image in
          DispatchQueue.main.async {
            onComplete(image)
          }
        },
        onError: { error in
          DispatchQueue.main.async {
            onComplete(nil)
          }
        }
      )
    }
  }

  // MARK: - Private Methods
  private func loadMoreReddits() {
    var afterName: String? = nil

    if let lastReddit = redditsList.last {
      afterName = lastReddit.name
    }

    DispatchQueue.main.async {
      if let view = self.view {
        view.showLoading()
      }
    }

    serviceAdapter.loadTopReddits(amount: pageSize, afterName: afterName,
      onComplete: { redditsList in
        self.redditsList.append(contentsOf: redditsList)
        DispatchQueue.main.async {
          if let view = self.view {
            view.hideLoading()
            view.refreshRedditsList()
          }
        }
      },
      onError: { error in
        print(error)
        DispatchQueue.main.async {
          if let view = self.view {
            view.hideLoading()
            view.displayLoadingError(message: "Error loading reddits. Please try again later.")
          }
        }
      }
    )
  }
}
