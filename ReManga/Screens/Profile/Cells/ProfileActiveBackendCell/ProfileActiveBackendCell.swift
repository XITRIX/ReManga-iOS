//
//  ProfileActiveBackendCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 10.05.2023.
//

import UIKit
import MvvmFoundation

class ProfileActiveBackendCell<VM: ProfileActiveBackendViewModel>: MvvmCollectionViewListCell<VM> {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var detailsLabel: UILabel!

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            titleLabel.rx.text <- viewModel.title
            detailsLabel.rx.text <- viewModel.detailsTitle
        }
    }

}
