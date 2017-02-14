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
  fileprivate var presenter: ListRedditsPresenter!
  fileprivate var redditModelForDetails: RedditModel?

  // MARK: - ViewController lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()

    //TableView Setup
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = estimatedRowHeight
    tableView.separatorStyle = .none

    //Pull to refresh setup
    refreshControl?.addTarget(self, action: #selector(refreshRequested), for: .valueChanged)

    //Presenter Setup
    let presenterFactory = ListRedditsPresenterFactory(view: self)
    presenter = presenterFactory.presenter
  }

  override func viewWillAppear(_ animated: Bool) {
    presenter.start()
  }

  override func encodeRestorableState(with coder: NSCoder) {
    super.encodeRestorableState(with: coder)
    presenter.saveState(coder: coder)
  }

  override func decodeRestorableState(with coder: NSCoder) {
    super.decodeRestorableState(with: coder)
    presenter.restoreState(coder: coder)
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

  // MARK: - Pull to refresh handler
  @objc func refreshRequested(refreshControl: UIRefreshControl) {
    presenter.refresh()
  }
}

extension ListRedditsViewController: UIDataSourceModelAssociation {

  func modelIdentifierForElement(at indexPath: IndexPath, in view: UIView) -> String? {
    guard let elementModel = presenter.elementModel(forPosition: indexPath.row) else {
      return nil
    }

    return elementModel.name
  }

  func indexPathForElement(withModelIdentifier identifier: String, in view: UIView) -> IndexPath? {
    guard let elementPosition = presenter.elementPosition(forName: identifier) else {
      return nil
    }

    return IndexPath(row: elementPosition, section: 0)
  }
}

extension ListRedditsViewController: ListRedditsViewProtocol {

  func showLoading() {
    refreshControl?.beginRefreshing()
  }

  func hideLoading() {
    refreshControl?.endRefreshing()
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
