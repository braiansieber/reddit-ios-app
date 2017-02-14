//
//  ListRedditsViewProtocol.swift
//  Reddit-App
//
//  Created by Marcelo Busico on 11/2/17.
//  Copyright © 2017 Busico. All rights reserved.
//

import Foundation

protocol ListRedditsViewProtocol: class {

  func showLoading()

  func hideLoading()

  func displayMessage(title: String, message: String)

  func refreshRedditsList()

  func showDetailsScreen(forModel model: RedditModel)
}
