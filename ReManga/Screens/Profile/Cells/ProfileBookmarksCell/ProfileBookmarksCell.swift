//
//  ProfileBookmarksCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 11.05.2023.
//

import UIKit
import MvvmFoundation

class ProfileBookmarksCell<VM: ProfileBookmarksViewModel>: MvvmCollectionViewListCell<VM> {
    @IBOutlet private var titleLabel: UILabel!

    override func initSetup() {
        accessories = [.disclosureIndicator()]
    }

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            titleLabel.rx.text <- viewModel.title
        }
    }

}
