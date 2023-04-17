//
//  MangaReaderPageCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 15.04.2023.
//

import UIKit
import MvvmFoundation
import Kingfisher

class MangaReaderPageCell<VM: MangaReaderPageViewModel>: MvvmCollectionViewCell<VM> {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var activityView: UIActivityIndicatorView!
    @IBOutlet private var widthConstraint: NSLayoutConstraint!
    private var imageSize: CGSize?

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            rx.imageSize <- viewModel.imageSize
            imageView.rx.imageUrl(with: activityView) <- viewModel.imageUrl
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let imageSize else { return }
        widthConstraint.constant = frame.height / imageSize.height * imageSize.width
    }
}
