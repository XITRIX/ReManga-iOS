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
    @IBOutlet private var downloadCancelButton: UIButton!
    @IBOutlet private var selectAllButton: UIButton!
    @IBOutlet private var revertChaptersButton: UIButton!
    @IBOutlet private var unrevertChaptersButton: UIButton!

    @IBOutlet private var editViews: [UIView]!
    @IBOutlet private var nonEditViews: [UIView]!

    private var trailingSeparatorConstraint: NSLayoutConstraint!

    override func initSetup() {
        var conf = defaultBackgroundConfiguration()
        conf.backgroundColor = .clear
        backgroundConfiguration = conf

        separatorLayoutGuide.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        trailingSeparatorConstraint = separatorLayoutGuide.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
    }

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            viewModel.downloadButtonTap <- downloadButton.rx.tap
            viewModel.downloadCancelTap <- downloadCancelButton.rx.tap
            viewModel.selectAll <- selectAllButton.rx.tap

            viewModel.downloadState.bind { [unowned self] download in
                UIView.animate(withDuration: 0.3) { [self] in
                    downloadButton.configuration = download ? downloadButton.configuration?.toFilled() : downloadButton.configuration?.toTinted()
                    nonEditViews.forEach { $0.collectionHidden = download }
                    editViews.forEach { $0.collectionHidden = !download }
                }
            }

            viewModel.revertChapters <- revertChaptersButton.rx.tap
            viewModel.unrevertChapters <- unrevertChaptersButton.rx.tap

            revertChaptersButton.rx.tintColor <- viewModel.chaptersReverted.map { $0 ? .tintColor : .secondaryLabel }
            unrevertChaptersButton.rx.tintColor <- viewModel.chaptersReverted.map { $0 ? .secondaryLabel : .tintColor }
        }
    }

    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        trailingSeparatorConstraint.isActive = layoutMargins.right > window?.rootViewController?.systemMinimumLayoutMargins.trailing ?? 0
    }
}
