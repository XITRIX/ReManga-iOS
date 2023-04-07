//
//  MangaDetailsChapterCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 14.04.2023.
//

import UIKit
import RxSwift
import MvvmFoundation

class MangaDetailsChapterCell<VM: MangaDetailsChapterViewModel>: MvvmCollectionViewListCell<VM> {
    @IBOutlet private var tomeLabel: UILabel!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!

    override func initSetup() {
        accessories = [.disclosureIndicator()]
    }

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            tomeLabel.rx.text <- viewModel.tome
            nameLabel.rx.text <- viewModel.chapter
            dateLabel.rx.text <- viewModel.date
        }
    }
}
