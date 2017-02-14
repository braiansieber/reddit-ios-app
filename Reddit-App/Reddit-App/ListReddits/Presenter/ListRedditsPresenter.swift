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
    if redditsList.isEmpty {
      loadRedditsAsync(appendToCurrentRedditsList: false)
    }
  }

  func refresh() {
    loadRedditsAsync(appendToCurrentRedditsList: false)
  }

  func saveState(coder: NSCoder) {
    coder.encode(redditsList, forKey: "redditsList")
  }

  func restoreState(coder: NSCoder) {
    if let redditsList = coder.decodeObject(forKey: "redditsList") as? [RedditModel] {
      self.redditsList = redditsList
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
      loadRedditsAsync(appendToCurrentRedditsList: true)
    }

    return redditsList[position]
  }

  func elementPosition(forName name: String) -> Int? {
    return redditsList.index { (redditModel) -> Bool in
      return redditModel.name == name
    }
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

  func elementSelected(atPosition position: Int) {
    guard let redditModel = elementModel(forPosition: position),
          redditModel.imageURL != nil else {
      return
    }

    view?.showDetailsScreen(forModel: redditModel)
  }

  // MARK: - Private Methods
  private func loadRedditsAsync(appendToCurrentRedditsList: Bool) {
    var afterName: String? = nil

    if appendToCurrentRedditsList,
       let lastReddit = redditsList.last {

      afterName = lastReddit.name
    }

    self.view?.showLoading()

    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
      self.serviceAdapter.loadTopReddits(amount: self.pageSize, afterName: afterName,
        onComplete: { redditsList in
          if appendToCurrentRedditsList {
            self.redditsList.append(contentsOf: redditsList)
          } else {
            self.redditsList = redditsList
          }
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
              view.displayMessage(title: "Error", message: "Error loading reddits. Please try again later.")
            }
          }
        }
      )
    }
  }
}
