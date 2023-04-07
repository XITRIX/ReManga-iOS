//
//  MangaDetailsTagCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 14.04.2023.
//

import MvvmFoundation
import UIKit

class MangaDetailsTagCell<VM: MangaDetailsTagViewModel>: MvvmCollectionViewCell<VM> {
    @IBOutlet private var button: UIButton!

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            button.rx.title() <- viewModel.title
        }
    }
}
