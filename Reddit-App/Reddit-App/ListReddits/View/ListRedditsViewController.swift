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
  let redditCellReuseIdentifier = "RedditCell"
  let estimatedRowHeight: CGFloat = 200

  // MARK: - Properties
  var presenter: ListRedditsPresenter!

  // MARK: - ViewController lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()

    let presenterFactory = ListRedditsPresenterFactory(view: self)
    self.presenter = presenterFactory.presenter

    //Automatic Row Dimension
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = estimatedRowHeight
  }

  override func viewWillAppear(_ animated: Bool) {
    presenter.start()
  }

  // MARK: - UITableViewDataSource
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.numberOfElements()
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
    return redditViewCell
  }

  // MARK: - UITableViewDelegate
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

extension ListRedditsViewController: ListRedditsViewProtocol {

  func showLoading() {
    //TODO: To be implemented
  }

  func hideLoading() {
    //TODO: To be implemented
  }

  func displayLoadingError(message: String) {
    //TODO: To be implemented
  }

  func refreshRedditsList() {
    tableView.reloadData()
  }
}
