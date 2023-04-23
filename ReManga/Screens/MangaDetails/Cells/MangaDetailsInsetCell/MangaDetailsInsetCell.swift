//
//  MangaDetailsInsetCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 23.04.2023.
//

import UIKit
import MvvmFoundation

class MangaDetailsInsetCell<VM: MangaDetailsInsetViewModel>: MvvmCollectionViewListCell<VM> {
    @IBOutlet private var heightConstraint: NSLayoutConstraint!

    override func initSetup() {
        var conf = defaultBackgroundConfiguration()
        conf.backgroundColor = .clear
        backgroundConfiguration = conf
        isUserInteractionEnabled = false
    }

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            viewModel.height.bind { [unowned self] height in
                heightConstraint.constant = height
                invalidateIntrinsicContentSize()
            }
        }
    }

}
