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
    @IBOutlet private var bookmarkHolderView: UIView!
    @IBOutlet private var bookmarkLabel: UILabel!

    private var type: ApiMangaNewChapterType?

    override func initSetup() {
        bookmarkHolderView.layer.cornerRadius = 8
        bookmarkHolderView.layer.cornerCurve = .continuous

        imageView.layer.cornerRadius = 12
        imageView.layer.cornerCurve = .continuous

//        hoverStyle = .init(effect: .lift, shape: .roundedRect(cornerRadius: 8))
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if previousTraitCollection?.hasDifferentColorAppearance(comparedTo: traitCollection) ?? false {
            applyBorderType()
        }
    }

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            titleLabel.rx.text <- viewModel.title
            imageView.rx.imageUrl(with: activityIndicator) <- viewModel.img
            bookmarkHolderView.rx.isHidden <- viewModel.bookmark.map { $0 == nil }
            bookmarkLabel.rx.text <- viewModel.bookmark.map { $0?.name }
            viewModel.newChapterType.bind { [unowned self] type in
                imageView.layer.borderWidth = type != nil ? 1 : 0
                self.type = type
                applyBorderType()
            }
        }
    }

    private func applyBorderType() {
        imageView.borderColor = type.color?.withAlphaComponent(0.6)
//        bookmarkHolderView.backgroundColor = type.color?.withAlphaComponent(0.6)
    }
}

private extension Optional where Wrapped == ApiMangaNewChapterType {
    var color: UIColor? {
        switch self {
        case .none:
            return nil
        case .free:
            return .systemBlue
        case .paid:
            return .systemRed
        }
    }
}
