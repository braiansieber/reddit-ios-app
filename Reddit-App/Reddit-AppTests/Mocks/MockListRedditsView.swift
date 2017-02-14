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
  var displayMessageCalls = 0
  var displayMessageCallback: () -> Void = {}
  var refreshRedditsListCalls = 0
  var refreshRedditsListCallback: () -> Void = {}
  var showDetailsScreenCalls = 0

  func showLoading() {
    showLoadingCalls += 1
  }

  func hideLoading() {
    hideLoadingCalls += 1
  }

  func displayMessage(title: String, message: String) {
    displayMessageCalls += 1
    displayMessageCallback()
  }

  func refreshRedditsList() {
    refreshRedditsListCalls += 1
    refreshRedditsListCallback()
  }

  func showDetailsScreen(forModel: RedditModel) {
    showDetailsScreenCalls += 1
  }
}
