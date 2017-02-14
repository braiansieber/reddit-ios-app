//
//  ViewRedditDetailsPresenter.swift
//  Reddit-App
//
//  Created by Marcelo Busico on 13/2/17.
//  Copyright © 2017 Busico. All rights reserved.
//

import UIKit

class ViewRedditDetailsPresenter {

  // MARK: - Properties
  private weak var view: ViewRedditDetailsViewProtocol?
  private let serviceAdapter: RedditServiceAdapterProtocol
  private var redditModel: RedditModel?

  // MARK: - Initialization
  init(view: ViewRedditDetailsViewProtocol, serviceAdapter: RedditServiceAdapterProtocol) {
    self.view = view
    self.serviceAdapter = serviceAdapter
  }

  // MARK: - Internal Methods
  func start(withModel model: RedditModel?) {
    self.redditModel = model
    loadRedditDetailsAsync()
  }

  // MARK: - Private Methods
  private func loadRedditDetailsAsync() {
    guard let imageURL = self.redditModel?.imageURL else {
      self.view?.displayMessage(title: "Error", message: "Reddit without image details.")
      return
    }

    self.view?.showLoading()

    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
      self.serviceAdapter.downloadImage(withURL: imageURL,
        onComplete: { image in
          DispatchQueue.main.async {
            if let view = self.view {
              view.hideLoading()
              view.displayImage(image)
            }
          }
        },
        onError: { error in
          print(error)
          DispatchQueue.main.async {
            if let view = self.view {
              view.hideLoading()
              view.displayMessage(title: "Error", message: "Error loading reddit details. Please try again later.")
            }
          }
        }
      )
    }
  }
}
