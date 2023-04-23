//
//  MangaDetailsLoadingPlaceholderCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 16.04.2023.
//

import UIKit
import MvvmFoundation

class MangaDetailsLoadingPlaceholderCell<VM: MangaDetailsLoadingPlaceholderViewModel>: MvvmCollectionViewListCell<VM> {
    @IBOutlet private var activityView: UIActivityIndicatorView!
    @IBOutlet var largeConstraints: [NSLayoutConstraint]!
    @IBOutlet var compactConstraints: [NSLayoutConstraint]!

    override func initSetup() {
        var conf = defaultBackgroundConfiguration()
        conf.backgroundColor = .clear
        backgroundConfiguration = conf
    }
    
    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            viewModel.isLoading.bind { [unowned self] loading in
                activityView.setAnimation(loading)
                invalidateIntrinsicContentSize()
            }

            viewModel.isCompact.bind { [unowned self] compact in
                setCompact(compact)
            }
        }
    }

    private func setCompact(_ compact: Bool) {
        largeConstraints.forEach { $0.isActive = !compact }
        compactConstraints.forEach { $0.isActive = compact }
        activityView.style = compact ? .medium : .large
    }

}
