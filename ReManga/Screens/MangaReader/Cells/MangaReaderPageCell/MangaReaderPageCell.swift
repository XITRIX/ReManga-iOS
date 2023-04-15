//
//  MangaReaderPageCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 15.04.2023.
//

import UIKit
import Kingfisher

class MangaReaderPageCell: UICollectionViewCell {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var widthConstraint: NSLayoutConstraint!
    private var imageSize: CGSize?

    func setup(with model: ApiMangaChapterPageModel) {
        imageSize = model.size
        imageView.kf.setImage(with: URL(string: model.path))
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let imageSize else { return }
        widthConstraint.constant = frame.height / imageSize.height * imageSize.width
    }
}
