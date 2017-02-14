//
//  ViewRedditDetailsViewProtocol.swift
//  Reddit-App
//
//  Created by Marcelo Busico on 13/2/17.
//  Copyright © 2017 Busico. All rights reserved.
//

import UIKit

protocol ViewRedditDetailsViewProtocol: class {

  func showLoading()

  func hideLoading()

  func displayMessage(title: String, message: String)

  func displayImage(_ image: UIImage)
}
