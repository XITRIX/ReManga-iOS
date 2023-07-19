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
    @IBOutlet private var progress: RoundedProgress!

    var trailingSeparatorConstraint: NSLayoutConstraint!

    override func initSetup() {
        separatorLayoutGuide.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        trailingSeparatorConstraint = separatorLayoutGuide.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
    }

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            titleLabel.rx.text <- viewModel.chapter
            tomeLabel.rx.text <- viewModel.tome

            viewModel.progress.bind { [unowned self] value in
                let inProgress = value != nil && value! < 1
                progress.isHidden = !inProgress
                progress.progress = value ?? 0
                accessories = inProgress ? [] : [.disclosureIndicator()]
                titleLabel.textColor = inProgress ? .secondaryLabel : .label
            }
        }
    }

    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        trailingSeparatorConstraint.isActive = layoutMargins.right > window?.rootViewController?.systemMinimumLayoutMargins.trailing ?? 0
    }
}
