//
//  TitleTranslatorView.swift
//  ReManga
//
//  Created by Даниил Виноградов on 05.11.2021.
//

import UIKit

class TitleTranslatorView: NibLoadableView {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!

    func configure(with model: ReTitlePublisher) {
        imageView.setImage(ReClient.baseUrl.appending(model.img ?? ""))
        titleLabel.text = model.name
        descriptionLabel.text = model.tagline
        descriptionLabel.isHidden = model.tagline?.isEmpty ?? true
    }
}
