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

    //Loading indicator
    loadingIndicator.center = view.center
    view.addSubview(loadingIndicator)

    //Presenter Setup
    let presenterFactory = ViewRedditDetailsPresenterFactory(view: self)
    self.presenter = presenterFactory.presenter
  }

  override func viewWillAppear(_ animated: Bool) {
    presenter.start(withModel: redditModel)
  }

  override func encodeRestorableState(with coder: NSCoder) {
    super.encodeRestorableState(with: coder)
    presenter.saveState(coder: coder)
  }

  override func decodeRestorableState(with coder: NSCoder) {
    super.decodeRestorableState(with: coder)
    presenter.restoreState(coder: coder)
  }

  // MARK: - Actions
  @IBAction func saveImageAction(_ sender: Any) {
    presenter.saveImage(imageView.image)
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
