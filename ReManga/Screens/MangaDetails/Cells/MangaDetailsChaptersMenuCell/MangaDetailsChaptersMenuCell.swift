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

    @IBOutlet private var editViews: [UIView]!
    @IBOutlet private var nonEditViews: [UIView]!

    override func initSetup() {
        var conf = defaultBackgroundConfiguration()
        conf.backgroundColor = .clear
        backgroundConfiguration = conf
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
        }
    }
}
