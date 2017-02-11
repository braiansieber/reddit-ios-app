//
//  ListRedditsPresenter.swift
//  Reddit-App
//
//  Created by Marcelo Busico on 11/2/17.
//  Copyright © 2017 Busico. All rights reserved.
//

import Foundation

class ListRedditsPresenter {

  let view: ListRedditsViewProtocol
  let serviceAdapter: RedditServiceAdapterProtocol

  init(view: ListRedditsViewProtocol, serviceAdapter: RedditServiceAdapterProtocol) {
    self.view = view
    self.serviceAdapter = serviceAdapter
  }
}
