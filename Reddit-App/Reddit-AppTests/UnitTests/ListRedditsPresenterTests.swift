//
//  ListRedditsPresenterTests.swift
//  Reddit-AppTests
//
//  Created by Marcelo Busico on 11/2/17.
//  Copyright © 2017 Busico. All rights reserved.
//

import XCTest
@testable import Reddit_App

class ListRedditsPresenterTests: XCTestCase {

  // MARK: - Tests constants
  let expectationTimeOut: TimeInterval = 10

  // MARK: - Tests properties
  var view: MockListRedditsView!
  var serviceAdapter: MockRedditServiceAdapter!
  var presenter: ListRedditsPresenter!

  // MARK: - Common tests setup
  override func setUp() {
    super.setUp()
    view = MockListRedditsView()
    serviceAdapter = MockRedditServiceAdapter()
    presenter = ListRedditsPresenter(view: view, serviceAdapter: serviceAdapter)
  }

  // MARK: - start method tests
  func testStart_withServiceError_shouldDisplayErrorMessage() {
    //Setup
    let asyncExpectation = expectation(description: "testStart")
    serviceAdapter.redditsList = nil

    //Test
    presenter.start()

    //Verify
    view.displayLoadingErrorsCallback = {
      XCTAssertEqual(1, self.view.showLoadingCalls, "Unexpected number of showLoading calls.")
      XCTAssertEqual(1, self.view.hideLoadingCalls, "Unexpected number of hideLoading calls.")
      XCTAssertEqual(1, self.view.displayLoadingErrorsCalls, "Unexpected number of displayLoadingErrors calls.")
      XCTAssertEqual(0, self.view.refreshRedditsListCalls, "Unexpected number of refreshRedditsList calls.")
      asyncExpectation.fulfill()
    }
    waitForExpectations(timeout: expectationTimeOut, handler: nil)
  }

  func testStart_withServiceSuccess_shouldDisplayAndHideLoadingAndRefreshList() {
    //Setup
    let asyncExpectation = expectation(description: "testStart")
    var redditsList = [RedditModel]()
    redditsList.append(MockRedditModel.mock(name: "name1"))
    redditsList.append(MockRedditModel.mock(name: "name2"))
    redditsList.append(MockRedditModel.mock(name: "name3"))
    serviceAdapter.redditsList = redditsList

    //Test
    presenter.start()

    view.refreshRedditsListCallback = {
      //Verify
      XCTAssertEqual(1, self.view.showLoadingCalls, "Unexpected number of showLoading calls.")
      XCTAssertEqual(1, self.view.hideLoadingCalls, "Unexpected number of hideLoading calls.")
      XCTAssertEqual(0, self.view.displayLoadingErrorsCalls, "Unexpected number of displayLoadingErrors calls.")
      XCTAssertEqual(1, self.view.refreshRedditsListCalls, "Unexpected number of refreshRedditsList calls.")
      asyncExpectation.fulfill()
    }
    waitForExpectations(timeout: expectationTimeOut, handler: nil)
  }

  // MARK: - numberOfElements method tests
  func testNumberOfElements_beforeStart_shouldReturnZero() {
    //Test
    let numberOfElements = presenter.numberOfElements()

    //Verify
    XCTAssertEqual(0, numberOfElements, "Unexpected number of elements.")
  }

  func testNumberOfElements_callingStart_shouldReturnNumberOfReddits() {
    //Setup
    let asyncExpectation = expectation(description: "testNumberOfElements")
    var redditsList = [RedditModel]()
    redditsList.append(MockRedditModel.mock(name: "name1"))
    redditsList.append(MockRedditModel.mock(name: "name2"))
    redditsList.append(MockRedditModel.mock(name: "name3"))
    serviceAdapter.redditsList = redditsList
    presenter.start()

    view.refreshRedditsListCallback = {
      //Test
      let numberOfElements = self.presenter.numberOfElements()

      //Verify
      XCTAssertEqual(3, numberOfElements, "Unexpected number of elements.")
      XCTAssertEqual(1, self.view.showLoadingCalls, "Unexpected number of showLoading calls.")
      XCTAssertEqual(1, self.view.hideLoadingCalls, "Unexpected number of hideLoading calls.")
      XCTAssertEqual(1, self.view.refreshRedditsListCalls, "Unexpected number of refreshRedditsList calls.")
      asyncExpectation.fulfill()
    }
    waitForExpectations(timeout: expectationTimeOut, handler: nil)
  }

  // MARK: - elementModel method tests
  func testElementModel_notCallingStart_requestingFirstElementModel_shouldReturnNil() {
    //Test
    let firstElementModel = presenter.elementModel(forPosition: 0)

    //Verify
    XCTAssertNil(firstElementModel, "Element model should be nil with invalid position.")
  }

  func testElementModel_callingStart_requestingFirstElementModel_shouldReturnRedditModel() {
    //Setup
    let asyncExpectation = expectation(description: "testElementModel")
    var redditsList = [RedditModel]()
    redditsList.append(MockRedditModel.mock(name: "name1"))
    redditsList.append(MockRedditModel.mock(name: "name2"))
    redditsList.append(MockRedditModel.mock(name: "name3"))
    serviceAdapter.redditsList = redditsList
    presenter.start()

    view.refreshRedditsListCallback = {
      //Test
      let firstElementModel = self.presenter.elementModel(forPosition: 0)

      //Verify
      XCTAssertNotNil(firstElementModel, "Element model should not be nil.")
      XCTAssertEqual(1, self.view.showLoadingCalls, "Unexpected number of showLoading calls.")
      XCTAssertEqual(1, self.view.hideLoadingCalls, "Unexpected number of hideLoading calls.")
      XCTAssertEqual(1, self.view.refreshRedditsListCalls, "Unexpected number of refreshRedditsList calls.")
      asyncExpectation.fulfill()
    }
    waitForExpectations(timeout: expectationTimeOut, handler: nil)
  }

  func testElementModel_callingStart_requestingInvalidPosition_shouldReturnNil() {
    //Setup
    let asyncExpectation = expectation(description: "testElementModel")
    var redditsList = [RedditModel]()
    redditsList.append(MockRedditModel.mock(name: "name1"))
    redditsList.append(MockRedditModel.mock(name: "name2"))
    redditsList.append(MockRedditModel.mock(name: "name3"))
    serviceAdapter.redditsList = redditsList
    presenter.start()

    view.refreshRedditsListCallback = {
      //Test
      let elementModel = self.presenter.elementModel(forPosition: 3)

      //Verify
      XCTAssertNil(elementModel, "Element model should be nil with invalid position.")
      XCTAssertEqual(1, self.view.showLoadingCalls, "Unexpected number of showLoading calls.")
      XCTAssertEqual(1, self.view.hideLoadingCalls, "Unexpected number of hideLoading calls.")
      XCTAssertEqual(1, self.view.refreshRedditsListCalls, "Unexpected number of refreshRedditsList calls.")
      asyncExpectation.fulfill()
    }
    waitForExpectations(timeout: expectationTimeOut, handler: nil)
  }

  func testElementModel_callingStart_requestingLastElementModel_shouldLoadMoreElements() {
    //First load setup
    let asyncExpectationFirstLoad = expectation(description: "testElementModel")
    var redditsList = [RedditModel]()
    redditsList.append(MockRedditModel.mock(name: "name1"))
    redditsList.append(MockRedditModel.mock(name: "name2"))
    redditsList.append(MockRedditModel.mock(name: "name3"))
    serviceAdapter.redditsList = redditsList
    presenter.start()

    view.refreshRedditsListCallback = {
      //Test
      let firstElementModel = self.presenter.elementModel(forPosition: 0)

      //Verify
      XCTAssertNotNil(firstElementModel, "Element model should not be nil.")
      XCTAssertEqual(1, self.serviceAdapter.numberOfLoadCalls, "Unexpected number of load calls.")
      XCTAssertEqual(3, self.presenter.numberOfElements(), "Unexpected number of elements.")
      XCTAssertEqual(1, self.view.showLoadingCalls, "Unexpected number of showLoading calls.")
      XCTAssertEqual(1, self.view.hideLoadingCalls, "Unexpected number of hideLoading calls.")
      XCTAssertEqual(1, self.view.refreshRedditsListCalls, "Unexpected number of refreshRedditsList calls.")
      asyncExpectationFirstLoad.fulfill()
    }
    waitForExpectations(timeout: expectationTimeOut, handler: nil)

    //Change adapter elements
    let asyncExpectationSecondLoad = expectation(description: "testElementModel")
    redditsList = [RedditModel]()
    redditsList.append(MockRedditModel.mock(name: "name4"))
    redditsList.append(MockRedditModel.mock(name: "name5"))
    serviceAdapter.redditsList = redditsList

    //Trigger second load with latest element
    let thirdElementModel = presenter.elementModel(forPosition: 2)

    view.refreshRedditsListCallback = {
      //Verify
      XCTAssertNotNil(thirdElementModel, "Element model should not be nil.")
      XCTAssertEqual(2, self.serviceAdapter.numberOfLoadCalls, "Unexpected number of load calls.")
      XCTAssertEqual(5, self.presenter.numberOfElements(), "Unexpected number of elements.")
      XCTAssertEqual(2, self.view.showLoadingCalls, "Unexpected number of showLoading calls.")
      XCTAssertEqual(2, self.view.hideLoadingCalls, "Unexpected number of hideLoading calls.")
      XCTAssertEqual(2, self.view.refreshRedditsListCalls, "Unexpected number of refreshRedditsList calls.")
      asyncExpectationSecondLoad.fulfill()
    }
    waitForExpectations(timeout: expectationTimeOut, handler: nil)
  }
}
