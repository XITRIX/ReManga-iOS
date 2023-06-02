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

    var trailingSeparatorConstraint: NSLayoutConstraint!

    override func initSetup() {
        accessories = [.disclosureIndicator()]
        separatorLayoutGuide.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        trailingSeparatorConstraint = separatorLayoutGuide.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
    }

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            titleLabel.rx.text <- viewModel.chapter
            tomeLabel.rx.text <- viewModel.tome
        }
    }

    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        trailingSeparatorConstraint.isActive = layoutMargins.right > window?.rootViewController?.systemMinimumLayoutMargins.trailing ?? 0
    }
}
