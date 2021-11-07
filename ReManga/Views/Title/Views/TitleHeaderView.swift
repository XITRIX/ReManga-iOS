//
//  TitleHeaderView.swift
//  ReManga
//
//  Created by Даниил Виноградов on 04.11.2021.
//

import UIKit

class TitleHeaderView: UIView {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var engTitleLabel: UILabel!
    @IBOutlet var ruTitleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!

    @IBOutlet var readingStatusLabel: UILabel!
    @IBOutlet var readingStatusDetailsLabel: UILabel!
    @IBOutlet var readingStatusButton: UIControl!

    @IBOutlet var bookmarkStatusLabel: UILabel!
    @IBOutlet var bookmarkStatusButton: UIControl!

    @IBOutlet var imageTopConstraint: NSLayoutConstraint!
    @IBOutlet private var headerView: UIView!

    override func layoutSubviews() {
        super.layoutSubviews()
        let height: CGFloat = self.headerView.frame.height
        headerView.roundCorners(corners: [.topLeft, .topRight], radius: height)
    }
}
