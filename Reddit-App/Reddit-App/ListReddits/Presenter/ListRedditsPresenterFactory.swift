//
//  ListRedditsPresenterFactory.swift
//  Reddit-App
//
//  Created by Marcelo Busico on 11/2/17.
//  Copyright © 2017 Busico. All rights reserved.
//

import Foundation

class ListRedditsPresenterFactory {

  let presenter: ListRedditsPresenter

  init(view: ListRedditsViewProtocol) {
    let serviceAdapter = RedditServiceAdapter()
    presenter = ListRedditsPresenter(view: view, serviceAdapter: serviceAdapter)
  }
}
