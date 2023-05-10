//
//  MangaCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 07.04.2023.
//

import UIKit
import MvvmFoundation
import Kingfisher

class MangaCell<VM: MangaCellViewModelProtocol>: MvvmCollectionViewCell<VM> {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var bookmarkHolderView: UIVisualEffectView!
    @IBOutlet private var bookmarkLabel: UILabel!

    override func initSetup() {
        bookmarkHolderView.layer.cornerRadius = 8
        bookmarkHolderView.layer.cornerCurve = .continuous

        imageView.layer.cornerRadius = 12
        imageView.layer.cornerCurve = .continuous
    }

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            titleLabel.rx.text <- viewModel.title
            imageView.rx.imageUrl(with: activityIndicator) <- viewModel.img
            bookmarkHolderView.rx.isHidden <- viewModel.bookmark.map { $0 == nil }
            bookmarkLabel.rx.text <- viewModel.bookmark.map { $0?.name }
        }
    }

}
