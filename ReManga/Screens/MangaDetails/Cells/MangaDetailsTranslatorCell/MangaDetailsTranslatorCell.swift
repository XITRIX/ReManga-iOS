//
//  MangaDetailsTranslatorCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 16.04.2023.
//

import UIKit
import MvvmFoundation
import Kingfisher

class MangaDetailsTranslatorCell<VM: MangaDetailsTranslatorViewModel>: MvvmCollectionViewListCell<VM> {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var activityView: UIActivityIndicatorView!

    override func initSetup() {
        imageView.layer.cornerRadius = 16
        imageView.layer.cornerCurve = .continuous

        var conf = defaultBackgroundConfiguration()
        conf.backgroundColorTransformer = .init { _ in
                .clear
//            guard let state = self?.configurationState else { return .clear }
//            return state.isSelected || state.isHighlighted ? .gray : .clear
        }
        backgroundConfiguration = conf
    }

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            titleLabel.rx.text <- viewModel.title
            subtitleLabel.rx.text <- viewModel.subtitle
            imageView.rx.imageUrl(with: activityView) <- viewModel.image
        }
    }
}
