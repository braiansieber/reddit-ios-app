//
//  MockListRedditsView.swift
//  Reddit-AppTests
//
//  Created by Marcelo Busico on 11/2/17.
//  Copyright © 2017 Busico. All rights reserved.
//

import Foundation
@testable import Reddit_App

class MockListRedditsView: ListRedditsViewProtocol {

  var showLoadingCalls = 0
  var hideLoadingCalls = 0
  var displayLoadingErrorsCalls = 0
  var refreshRedditsListCalls = 0

  func showLoading() {
    showLoadingCalls += 1
  }

  func hideLoading() {
    hideLoadingCalls += 1
  }

  func displayLoadingError(message: String) {
    displayLoadingErrorsCalls += 1
  }

  func refreshRedditsList() {
    refreshRedditsListCalls += 1
  }
}
