//
//  ListRedditsViewController.swift
//  Reddit-App
//
//  Created by Marcelo Busico on 11/2/17.
//  Copyright © 2017 Busico. All rights reserved.
//

import UIKit

class ListRedditsViewController: UITableViewController {

  // MARK: - Properties
  var presenter: ListRedditsPresenter!

  // MARK: - ViewController lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()

    let presenterFactory = ListRedditsPresenterFactory(view: self)
    self.presenter = presenterFactory.presenter
  }

  override func viewWillAppear(_ animated: Bool) {
    presenter.start()
  }

  // MARK: - UITableViewDataSource
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.numberOfElements()
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let elementModel = presenter.elementModel(forPosition: indexPath.row) else {
      return UITableViewCell()
    }

    //TODO: To be implemented
    return UITableViewCell()
  }

  // MARK: - UITableViewDelegate
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
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
