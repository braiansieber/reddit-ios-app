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
}

extension ListRedditsViewController: ListRedditsViewProtocol {

}
