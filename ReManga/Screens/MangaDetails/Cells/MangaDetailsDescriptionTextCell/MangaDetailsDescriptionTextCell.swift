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
    private var viewModel: VM!

    override func setup(with viewModel: VM) {
        self.viewModel = viewModel
        bind(in: disposeBag) {
            viewModel.title.bind { [unowned self] text in
                textLabel.text = text
                invalidateIntrinsicContentSize()
            }
            viewModel.isExpanded.bind { [unowned self] expanded in
                textLabel.numberOfLines = expanded ? 0 : 4
                expandButton.isHidden = expanded || !textLabel.isTruncated
                invalidateIntrinsicContentSize()
            }
        }
    }

    @IBAction func expandAction(_ sender: UIButton) {
        viewModel.isExpanded.accept(true)
    }

}
