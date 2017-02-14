//
//  ViewRedditDetailsPresenterFactory.swift
//  Reddit-App
//
//  Created by Marcelo Busico on 13/2/17.
//  Copyright © 2017 Busico. All rights reserved.
//

import Foundation

class ViewRedditDetailsPresenterFactory {

  let presenter: ViewRedditDetailsPresenter

  init(view: ViewRedditDetailsViewProtocol) {
    let serviceAdapter = RedditServiceAdapter()
    presenter = ViewRedditDetailsPresenter(view: view, serviceAdapter: serviceAdapter)
  }
}
