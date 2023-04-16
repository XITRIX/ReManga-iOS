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

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            viewModel.isLoading.bind { [unowned self] loading in
                if loading {
                    activityView.startAnimating()
                } else {
                    activityView.stopAnimating()
                }
                invalidateIntrinsicContentSize()
            }
        }
    }


}
