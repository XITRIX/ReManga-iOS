//
//  MangaDetailsHeaderCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 16.04.2023.
//

import UIKit
import MvvmFoundation

class MangaDetailsHeaderCell<VM: MangaDetailsHeaderViewModel>: MvvmCollectionViewListCell<VM> {
    @IBOutlet private var titleLabel: UILabel!

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            titleLabel.rx.text <- viewModel.title
        }
    }

}
