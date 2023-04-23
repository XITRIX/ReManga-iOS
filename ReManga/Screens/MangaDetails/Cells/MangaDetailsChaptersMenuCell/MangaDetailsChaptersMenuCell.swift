//
//  MangaDetailsChaptersMenuCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 23.04.2023.
//

import UIKit
import MvvmFoundation

class MangaDetailsChaptersMenuCell<VM: MangaDetailsChaptersMenuViewModel>: MvvmCollectionViewListCell<VM> {
    @IBOutlet private var downloadButton: UIButton!

    override func initSetup() {
        var conf = defaultBackgroundConfiguration()
        conf.backgroundColor = .clear
        backgroundConfiguration = conf
    }

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            viewModel.toggleDownload <- downloadButton.rx.tap
        }
    }
}
