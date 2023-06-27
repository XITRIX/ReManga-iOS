//
//  DetailsHeaderCap.swift
//  ReManga
//
//  Created by Даниил Виноградов on 13.04.2023.
//

import MvvmFoundation
import UIKit

class DetailsHeaderCap<VM: DetailsHeaderCapViewModel>: MvvmCollectionViewCell<VM> {
    @IBOutlet private var cardView: UIView!
    @IBOutlet private var rating: UILabel!
    @IBOutlet private var likes: UILabel!
    @IBOutlet private var sees: UILabel!
    @IBOutlet private var bookmarks: UILabel!

    override func initSetup() {
        cardView.layer.cornerRadius = 16
        cardView.layer.cornerCurve = .continuous
    }

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            rating.rx.text <- viewModel.rating
            likes.rx.text <- viewModel.likes
            sees.rx.text <- viewModel.sees
            bookmarks.rx.text <- viewModel.bookmarks
        }
    }
}
