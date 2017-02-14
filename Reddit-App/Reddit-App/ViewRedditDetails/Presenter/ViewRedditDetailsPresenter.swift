//
//  ViewRedditDetailsPresenter.swift
//  Reddit-App
//
//  Created by Marcelo Busico on 13/2/17.
//  Copyright © 2017 Busico. All rights reserved.
//

import UIKit

class ViewRedditDetailsPresenter: NSObject {

  // MARK: - Properties
  private weak var view: ViewRedditDetailsViewProtocol?
  private let serviceAdapter: RedditServiceAdapterProtocol
  private var redditModel: RedditModel?
  private var redditImage: UIImage?

  // MARK: - Initialization
  init(view: ViewRedditDetailsViewProtocol, serviceAdapter: RedditServiceAdapterProtocol) {
    self.view = view
    self.serviceAdapter = serviceAdapter
  }

  // MARK: - Internal Methods
  func start(withModel model: RedditModel?) {
    if let updatedModel = model {
      self.redditModel = updatedModel
      self.redditImage = nil
    }

    loadRedditDetailsAsync()
  }

  func saveState(coder: NSCoder) {
    coder.encode(redditModel, forKey: "redditModel")
    coder.encode(redditImage, forKey: "redditImage")
  }

  func restoreState(coder: NSCoder) {
    if let redditModel = coder.decodeObject(forKey: "redditModel") as? RedditModel {
      self.redditModel = redditModel
      self.redditImage = coder.decodeObject(forKey: "redditImage") as? UIImage
    }
  }

  func saveImage(_ image: UIImage?) {
    guard let image = image else {
      return
    }

    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
      UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.didFinishSavingImage(_:error:contextInfo:)), nil)
    }
  }

  // MARK: - Save Image To Photo Album Methods
  @objc func didFinishSavingImage(_ image: UIImage, error: Error?, contextInfo: UnsafeRawPointer) {
    if let view = self.view {
      if error == nil {
        view.displayMessage(title: "Success!", message: "Please check your gallery to find your saved reddit image.")
      } else {
        view.displayMessage(title: "Error", message: "Error saving image into your gallery. Please check Reddit application settings and grant Photos permissions.")
      }
    }
  }

  // MARK: - Private Methods
  private func loadRedditDetailsAsync() {
    guard let imageURL = self.redditModel?.imageURL else {
      self.view?.displayMessage(title: "Error", message: "Reddit without image details.")
      return
    }

    if let redditImage = redditImage {
      self.view?.displayImage(redditImage)
      return
    }

    self.view?.showLoading()

    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
      self.serviceAdapter.downloadImage(withURL: imageURL,
        onComplete: { image in
          DispatchQueue.main.async {
            if let view = self.view {
              self.redditImage = image
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
