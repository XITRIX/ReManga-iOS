//
//  MangaDetailsCommentCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 16.04.2023.
//

import UIKit
import MvvmFoundation

class MangaDetailsCommentCell<VM: MangaDetailsCommentViewModel>: MvvmCollectionViewCell<VM> {
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var scoreLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var messageContainer: UIView!

    override func initSetup() {
        imageView.layer.cornerRadius = 16
        imageView.layer.cornerCurve = .continuous

        messageContainer.layer.cornerRadius = 16
        messageContainer.layer.cornerCurve = .continuous
        messageContainer.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            nameLabel.rx.text <- viewModel.name
            dateLabel.rx.text <- viewModel.date
            textLabel.rx.attributedText <- viewModel.content
            scoreLabel.rx.text <- viewModel.score
            imageView.rx.imageUrl <- viewModel.image
        }
    }

}
