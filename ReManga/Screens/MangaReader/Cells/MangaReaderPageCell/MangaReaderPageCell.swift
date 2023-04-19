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
    private var aspectRatioConstraint: NSLayoutConstraint!

    @Injected var api: ApiProtocol

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            imageView.rx.imageUrl(with: activityView, auth: api.kfAuthModifier) <- viewModel.imageUrl
            viewModel.imageSize.bind { [unowned self] size in
                if aspectRatioConstraint != nil {
                    aspectRatioConstraint.isActive = false
                }

                aspectRatioConstraint = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: size.height / size.width)
                aspectRatioConstraint.isActive = true
                invalidateIntrinsicContentSize()
            }
        }
    }

//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        guard let imageSize else { return }
//        widthConstraint.constant = frame.height / imageSize.height * imageSize.width
//    }
}
