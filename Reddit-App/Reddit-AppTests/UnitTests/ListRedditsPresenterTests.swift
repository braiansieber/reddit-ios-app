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
    serviceAdapter.redditsList = nil

    //Test
    presenter.start()

    //Verify
    XCTAssertEqual(1, view.showLoadingCalls, "Unexpected number of showLoading calls.")
    XCTAssertEqual(1, view.hideLoadingCalls, "Unexpected number of hideLoading calls.")
    XCTAssertEqual(1, view.displayLoadingErrorsCalls, "Unexpected number of displayLoadingErrors calls.")
    XCTAssertEqual(0, view.refreshRedditsListCalls, "Unexpected number of refreshRedditsList calls.")
  }

  func testStart_withServiceSuccess_shouldDisplayAndHideLoadingAndRefreshList() {
    //Setup
    var redditsList = [RedditModel]()
    redditsList.append(MockRedditModel.mock(name: "name1"))
    redditsList.append(MockRedditModel.mock(name: "name2"))
    redditsList.append(MockRedditModel.mock(name: "name3"))
    serviceAdapter.redditsList = redditsList

    //Test
    presenter.start()

    //Verify
    XCTAssertEqual(1, view.showLoadingCalls, "Unexpected number of showLoading calls.")
    XCTAssertEqual(1, view.hideLoadingCalls, "Unexpected number of hideLoading calls.")
    XCTAssertEqual(0, view.displayLoadingErrorsCalls, "Unexpected number of displayLoadingErrors calls.")
    XCTAssertEqual(1, view.refreshRedditsListCalls, "Unexpected number of refreshRedditsList calls.")
  }

  // MARK: - numberOfElements method tests
  func testNumberOfElements_beforeStart_shouldReturnZero() {
    //Test
    let numberOfElements = presenter.numberOfElements()

    //Verify
    XCTAssertEqual(0, numberOfElements, "Unexpected number of elements.")
    XCTAssertEqual(0, view.showLoadingCalls, "Unexpected number of showLoading calls.")
    XCTAssertEqual(0, view.hideLoadingCalls, "Unexpected number of hideLoading calls.")
    XCTAssertEqual(0, view.refreshRedditsListCalls, "Unexpected number of refreshRedditsList calls.")
  }

  func testNumberOfElements_callingStart_shouldReturnNumberOfReddits() {
    //Setup
    var redditsList = [RedditModel]()
    redditsList.append(MockRedditModel.mock(name: "name1"))
    redditsList.append(MockRedditModel.mock(name: "name2"))
    redditsList.append(MockRedditModel.mock(name: "name3"))
    serviceAdapter.redditsList = redditsList
    presenter.start()

    //Test
    let numberOfElements = presenter.numberOfElements()

    //Verify
    XCTAssertEqual(3, numberOfElements, "Unexpected number of elements.")
    XCTAssertEqual(1, view.showLoadingCalls, "Unexpected number of showLoading calls.")
    XCTAssertEqual(1, view.hideLoadingCalls, "Unexpected number of hideLoading calls.")
    XCTAssertEqual(1, view.refreshRedditsListCalls, "Unexpected number of refreshRedditsList calls.")
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
    var redditsList = [RedditModel]()
    redditsList.append(MockRedditModel.mock(name: "name1"))
    redditsList.append(MockRedditModel.mock(name: "name2"))
    redditsList.append(MockRedditModel.mock(name: "name3"))
    serviceAdapter.redditsList = redditsList
    presenter.start()

    //Test
    let firstElementModel = presenter.elementModel(forPosition: 0)

    //Verify
    XCTAssertNotNil(firstElementModel, "Element model should not be nil.")
    XCTAssertEqual(1, view.showLoadingCalls, "Unexpected number of showLoading calls.")
    XCTAssertEqual(1, view.hideLoadingCalls, "Unexpected number of hideLoading calls.")
    XCTAssertEqual(1, view.refreshRedditsListCalls, "Unexpected number of refreshRedditsList calls.")
  }

  func testElementModel_callingStart_requestingInvalidPosition_shouldReturnNil() {
    //Setup
    var redditsList = [RedditModel]()
    redditsList.append(MockRedditModel.mock(name: "name1"))
    redditsList.append(MockRedditModel.mock(name: "name2"))
    redditsList.append(MockRedditModel.mock(name: "name3"))
    serviceAdapter.redditsList = redditsList
    presenter.start()

    //Test
    let elementModel = presenter.elementModel(forPosition: 3)

    //Verify
    XCTAssertNil(elementModel, "Element model should be nil with invalid position.")
    XCTAssertEqual(1, view.showLoadingCalls, "Unexpected number of showLoading calls.")
    XCTAssertEqual(1, view.hideLoadingCalls, "Unexpected number of hideLoading calls.")
    XCTAssertEqual(1, view.refreshRedditsListCalls, "Unexpected number of refreshRedditsList calls.")
  }

  func testElementModel_callingStart_requestingLastElementModel_shouldLoadMoreElements() {
    //Fisrt load setup
    var redditsList = [RedditModel]()
    redditsList.append(MockRedditModel.mock(name: "name1"))
    redditsList.append(MockRedditModel.mock(name: "name2"))
    redditsList.append(MockRedditModel.mock(name: "name3"))
    serviceAdapter.redditsList = redditsList
    presenter.start()

    //Test
    let firstElementModel = presenter.elementModel(forPosition: 0)

    //Verify
    XCTAssertNotNil(firstElementModel, "Element model should not be nil.")
    XCTAssertEqual(1, serviceAdapter.numberOfLoadCalls, "Unexpected number of load calls.")
    XCTAssertEqual(3, presenter.numberOfElements(), "Unexpected number of elements.")
    XCTAssertEqual(1, view.showLoadingCalls, "Unexpected number of showLoading calls.")
    XCTAssertEqual(1, view.hideLoadingCalls, "Unexpected number of hideLoading calls.")
    XCTAssertEqual(1, view.refreshRedditsListCalls, "Unexpected number of refreshRedditsList calls.")

    //Change adapter elements
    redditsList = [RedditModel]()
    redditsList.append(MockRedditModel.mock(name: "name4"))
    redditsList.append(MockRedditModel.mock(name: "name5"))
    serviceAdapter.redditsList = redditsList

    //Trigger second load with latest element
    let thirdElementModel = presenter.elementModel(forPosition: 2)

    //Verify
    XCTAssertNotNil(thirdElementModel, "Element model should not be nil.")
    XCTAssertEqual(2, serviceAdapter.numberOfLoadCalls, "Unexpected number of load calls.")
    XCTAssertEqual(5, presenter.numberOfElements(), "Unexpected number of elements.")
    XCTAssertEqual(2, view.showLoadingCalls, "Unexpected number of showLoading calls.")
    XCTAssertEqual(2, view.hideLoadingCalls, "Unexpected number of hideLoading calls.")
    XCTAssertEqual(2, view.refreshRedditsListCalls, "Unexpected number of refreshRedditsList calls.")
  }
}
