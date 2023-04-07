//
//  MangaDetailsDescriptionTextCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 14.04.2023.
//

import UIKit
import MvvmFoundation

class MangaDetailsDescriptionTextCell<VM: MangaDetailsDescriptionTextViewModel>: MvvmCollectionViewCell<VM> {
    @IBOutlet private var textLabel: UILabel!

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            textLabel.rx.text <- viewModel.title
        }
    }

}
