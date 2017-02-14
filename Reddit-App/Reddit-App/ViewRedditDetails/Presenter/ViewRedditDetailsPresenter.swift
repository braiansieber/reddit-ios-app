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

  func saveImage(_ image: UIImage?) {
    guard let image = image else {
      return
    }
    
    UIImageWriteToSavedPhotosAlbum(image, self, #selector(didFinishSavingImage(_:error:contextInfo:)), nil)
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
