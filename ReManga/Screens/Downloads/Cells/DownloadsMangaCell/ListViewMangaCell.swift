//
//  ListViewMangaCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 07.05.2023.
//

import UIKit
import MvvmFoundation
import Kingfisher

class ListViewMangaCell<VM: ListViewMangaViewModelProtocol>: MvvmCollectionViewListCell<VM> {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var backendLogo: UIImageView!
    @IBOutlet private var backendLogoHolder: UIVisualEffectView!

    private var trailingSeparatorConstraint: NSLayoutConstraint!

    override func initSetup() {
        imageView.layer.cornerRadius = 8
        imageView.layer.cornerCurve = .continuous
        accessories = [.disclosureIndicator()]

        backendLogoHolder.layer.cornerRadius = 4
        backendLogoHolder.layer.cornerCurve = .continuous

        separatorLayoutGuide.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        trailingSeparatorConstraint = separatorLayoutGuide.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
    }

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            titleLabel.rx.text <- viewModel.title
            subtitleLabel.rx.text <- viewModel.subtitle
            imageView.rx.imageUrl() <- viewModel.image
            backendLogo.rx.setImage() <- viewModel.backendImage
            backendLogoHolder.rx.isHidden <- viewModel.backendImage.map { $0 == nil }
        }
    }

    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        trailingSeparatorConstraint.isActive = layoutMargins.right > window?.rootViewController?.systemMinimumLayoutMargins.trailing ?? 0
    }
}
