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
  var displayLoadingErrorsCallback: () -> Void = {}
  var refreshRedditsListCalls = 0
  var refreshRedditsListCallback: () -> Void = {}

  func showLoading() {
    showLoadingCalls += 1
  }

  func hideLoading() {
    hideLoadingCalls += 1
  }

  func displayLoadingError(message: String) {
    displayLoadingErrorsCalls += 1
    displayLoadingErrorsCallback()
  }

  func refreshRedditsList() {
    refreshRedditsListCalls += 1
    refreshRedditsListCallback()
  }
}
