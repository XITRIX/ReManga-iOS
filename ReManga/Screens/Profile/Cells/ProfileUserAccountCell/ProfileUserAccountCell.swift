//
//  ProfileUserAccountCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 25.04.2023.
//

import MvvmFoundation
import UIKit

class ProfileUserAccountCell<VM: ProfileUserAccountViewModel>: MvvmCollectionViewListCell<VM> {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var currencyLabel: UILabel!

    override func initSetup() {
        accessories = [.disclosureIndicator()]
        imageView.layer.cornerRadius = 16
    }

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            titleLabel.rx.text <- viewModel.title
            
            imageView.rx.imageUrl() <- viewModel.image
            imageView.rx.isHidden <- viewModel.image.map { $0 == nil }

            currencyLabel.rx.textWithVisibility <- viewModel.currency
        }
    }
}
