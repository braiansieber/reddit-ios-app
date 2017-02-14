//
//  ListRedditsViewController.swift
//  Reddit-App
//
//  Created by Marcelo Busico on 11/2/17.
//  Copyright © 2017 Busico. All rights reserved.
//

import UIKit

class ListRedditsViewController: UITableViewController {

  // MARK: - Constants
  private let redditCellReuseIdentifier = "RedditCell"
  private let estimatedRowHeight: CGFloat = 200
  fileprivate let showImageSegueIdentifier = "showImage"

  // MARK: - Properties
  private var presenter: ListRedditsPresenter!
  fileprivate let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
  fileprivate var redditModelForDetails: RedditModel?

  // MARK: - ViewController lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()

    //TableView Setup
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = estimatedRowHeight
    tableView.separatorStyle = .none

    //Loading indicator
    loadingIndicator.center = view.center
    view.addSubview(loadingIndicator)

    //Presenter Setup
    let presenterFactory = ListRedditsPresenterFactory(view: self)
    presenter = presenterFactory.presenter
    presenter.start()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == showImageSegueIdentifier,
       let destinationViewController = segue.destination as? ViewRedditDetailsViewController {

      destinationViewController.redditModel = redditModelForDetails
    }
  }

  // MARK: - UITableViewDataSource
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let numberOfRows = presenter.numberOfElements()

    if numberOfRows > 0 {
      tableView.separatorStyle = .singleLine
    }

    return numberOfRows
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let emptyCell = UITableViewCell()

    guard let elementModel = presenter.elementModel(forPosition: indexPath.row) else {
      return emptyCell
    }

    guard let redditViewCell = tableView.dequeueReusableCell(withIdentifier: redditCellReuseIdentifier, for: indexPath) as? RedditViewCell else {
      return emptyCell
    }

    redditViewCell.model = elementModel

    presenter.loadThumbnailForModel(model: elementModel) { image in
      redditViewCell.setupThumbnail(withImage: image)
    }

    return redditViewCell
  }

  // MARK: - UITableViewDelegate
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    presenter.elementSelected(atPosition: indexPath.row)
  }
}

extension ListRedditsViewController: ListRedditsViewProtocol {

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

  func refreshRedditsList() {
    tableView.reloadData()
  }

  func showDetailsScreen(forModel model: RedditModel) {
    redditModelForDetails = model
    performSegue(withIdentifier: showImageSegueIdentifier, sender: self)
  }
}
