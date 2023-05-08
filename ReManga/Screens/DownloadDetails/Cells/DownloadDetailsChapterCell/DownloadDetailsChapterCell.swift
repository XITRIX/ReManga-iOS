//
//  DownloadDetailsChapterCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 08.05.2023.
//

import UIKit
import MvvmFoundation

class DownloadDetailsChapterCell<VM: DownloadDetailsChapterViewModel>: MvvmCollectionViewListCell<VM> {
    @IBOutlet private var tomeLabel: UILabel!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var teamLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!

    override func initSetup() {
        accessories = [.disclosureIndicator()]
    }

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            titleLabel.rx.text <- viewModel.chapter
            tomeLabel.rx.text <- viewModel.tome
        }
    }

}
