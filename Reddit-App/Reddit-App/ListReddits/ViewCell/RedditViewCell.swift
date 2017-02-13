//
//  RedditViewCell.swift
//  Reddit-App
//
//  Created by Marcelo Busico on 13/2/17.
//  Copyright © 2017 Busico. All rights reserved.
//

import UIKit

class RedditViewCell: UITableViewCell {

  // MARK: - Constants
  private let thumbnailWidth: CGFloat = 80

  // MARK: - Outlets
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var authorLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var commentsLabel: UILabel!

  // MARK: - Properties
  var model: RedditModel? {
    didSet {
      refreshView()
    }
  }

  // MARK: - Private methods
  private func refreshView() {
    guard let model = self.model else {
      titleLabel.text = String()
      authorLabel.text = String()
      dateLabel.text = String()
      commentsLabel.text = String()
      setupThumbnail(withImage: nil)
      return
    }

    titleLabel.text = model.title
    authorLabel.text = "By \(model.author)"
    dateLabel.text = "Submitted \(model.formattedTimeSinceSubmissions())"
    commentsLabel.text = "\(model.commentsCount) comments"
  }

  func setupThumbnail(withImage image: UIImage?) {
    var thumbnail = image

    if thumbnail == nil {
      thumbnail = UIImage(named: "noImage")
    }

    thumbnailImageView.image = thumbnail
  }
}
