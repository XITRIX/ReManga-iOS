//
//  MangaDetailsDescriptionTextCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 14.04.2023.
//

import UIKit
import MvvmFoundation

class MangaDetailsDescriptionTextCell<VM: MangaDetailsDescriptionTextViewModel>: MvvmCollectionViewCell<VM> {
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var expandButton: UIButton!

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
//            textLabel.rx.text <- viewModel.title
            viewModel.title.bind { [unowned self] text in
                textLabel.text = text
                textLabel.numberOfLines = 4
                expandButton.isHidden = !textLabel.isTruncated
                invalidateIntrinsicContentSize()
            }
        }
    }

    @IBAction func expandAction(_ sender: UIButton) {
        textLabel.numberOfLines = 0
        sender.isHidden = true
        invalidateIntrinsicContentSize()
    }
    //    override func layoutSubviews() {
//        super.layoutSubviews()
//    }

}
