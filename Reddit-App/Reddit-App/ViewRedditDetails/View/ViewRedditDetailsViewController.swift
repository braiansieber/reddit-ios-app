//
//  ViewRedditDetailsViewController.swift
//  Reddit-App
//
//  Created by Marcelo Busico on 13/2/17.
//  Copyright © 2017 Busico. All rights reserved.
//

import UIKit

class ViewRedditDetailsViewController: UIViewController {

  // MARK: - Outlets
  @IBOutlet weak var imageView: UIImageView!

  // MARK: - Properties
  private var presenter: ViewRedditDetailsPresenter!
  var redditModel: RedditModel?
  fileprivate let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

  // MARK: - ViewController lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()

    //Presenter Setup
    let presenterFactory = ViewRedditDetailsPresenterFactory(view: self)
    self.presenter = presenterFactory.presenter

    //Loading indicator
    loadingIndicator.center = view.center
    view.addSubview(loadingIndicator)
  }

  override func viewWillAppear(_ animated: Bool) {
    presenter.start(withModel: redditModel)
  }
}

extension ViewRedditDetailsViewController: ViewRedditDetailsViewProtocol {

  func showLoading() {
    loadingIndicator.startAnimating()
  }

  func hideLoading() {
    loadingIndicator.stopAnimating()
  }

  func displayMessage(title: String, message: String) {
    let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertViewController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alertViewController, animated: true, completion: nil)
  }

  func displayImage(_ image: UIImage) {
    imageView.image = image
  }
}
