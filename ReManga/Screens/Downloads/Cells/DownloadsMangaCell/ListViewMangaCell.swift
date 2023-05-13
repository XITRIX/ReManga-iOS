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

    override func initSetup() {
        imageView.layer.cornerRadius = 8
        imageView.layer.cornerCurve = .continuous
        accessories = [.disclosureIndicator()]
    }

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            titleLabel.rx.text <- viewModel.title
            subtitleLabel.rx.text <- viewModel.subtitle
            imageView.rx.imageUrl() <- viewModel.image
        }
    }

}
