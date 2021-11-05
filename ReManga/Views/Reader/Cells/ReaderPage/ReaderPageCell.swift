//
//  ReaderPageCell.swift
//  REManga
//
//  Created by Даниил Виноградов on 10.04.2021.
//

import UIKit

class ReaderPageCell: BaseTableViewCell {
    @IBOutlet var pageImage: UIImageView!
    @IBOutlet var loader: UIActivityIndicatorView!

    override func prepareForReuse() {
        super.prepareForReuse()
        loader.isHidden = false
        loader.startAnimating()
    }

    func setModel(_ model: ReChapterPage) {
        pageImage.kf.setImage(with: URL(string: model.link ?? "")) { result in
            self.loader.isHidden = true
            self.loader.stopAnimating()
        }
    }
}
