//
//  ListRedditsPresenter.swift
//  Reddit-App
//
//  Created by Marcelo Busico on 13/2/17.
//  Copyright © 2017 Busico. All rights reserved.
//

import Foundation

class ListRedditsPresenter {

  // MARK: - Constants
  let pageSize = 50

  // MARK: - Properties
  let view: ListRedditsViewProtocol
  let serviceAdapter: RedditServiceAdapterProtocol
  var redditsList = [RedditModel]()

  // MARK: - Initialization
  init(view: ListRedditsViewProtocol, serviceAdapter: RedditServiceAdapterProtocol) {
    self.view = view
    self.serviceAdapter = serviceAdapter
  }

  // MARK: - Internal Methods
  func start() {
    redditsList = [RedditModel]()
    loadMoreReddits()
  }

  func numberOfElements() -> Int {
    return redditsList.count
  }

  func elementModel(forPosition position: Int) -> RedditModel? {
    if position >= redditsList.count {
      return nil
    }

    if position == (redditsList.count - 1) {
      loadMoreReddits()
    }

    return redditsList[position]
  }

  // MARK: - Private Methods
  private func loadMoreReddits() {
    var afterName: String? = nil

    if let lastReddit = redditsList.last {
      afterName = lastReddit.name
    }

    view.showLoading()

    serviceAdapter.loadTopReddits(amount: pageSize, afterName: afterName,
      onComplete: { redditsList in
        self.redditsList.append(contentsOf: redditsList)
        self.view.refreshRedditsList()
        self.view.hideLoading()
      },
      onError: { error in
        self.view.hideLoading()
        self.view.displayLoadingError(message: "Error loading reddits. Please try again later.")
      }
    )
  }
}
