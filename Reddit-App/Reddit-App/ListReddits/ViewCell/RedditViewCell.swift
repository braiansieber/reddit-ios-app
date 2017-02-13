//
//  RedditViewCell.swift
//  Reddit-App
//
//  Created by Marcelo Busico on 13/2/17.
//  Copyright © 2017 Busico. All rights reserved.
//

import UIKit

class RedditViewCell: UITableViewCell {

  // MARK: - Outlets
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var authorLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var commentsLabel: UILabel!
  @IBOutlet weak var thumbnailLeftMarginConstraint: NSLayoutConstraint!
  @IBOutlet weak var thumbnailWidthConstraint: NSLayoutConstraint!

  // MARK: - Properties
  var model: RedditModel? {
    didSet {
      refreshView()
    }
  }

  // MARK: - Private methods
  private func refreshView() {
    thumbnailImageView.image = nil
    thumbnailImageView.isHidden = true
    thumbnailLeftMarginConstraint.constant = 8
    thumbnailWidthConstraint.constant = 0

    guard let model = self.model else {
      titleLabel.text = String()
      authorLabel.text = String()
      dateLabel.text = String()
      commentsLabel.text = String()
      return
    }

    titleLabel.text = model.title
    authorLabel.text = "By \(model.author)"
    dateLabel.text = "Submitted \(model.formattedTimeSinceSubmissions())"
    commentsLabel.text = "\(model.commentsCount) comments"
  }
}
