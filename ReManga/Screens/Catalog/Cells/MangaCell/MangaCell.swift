//
//  MangaCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 07.04.2023.
//

import UIKit
import MvvmFoundation
import Kingfisher

class MangaCell<VM: MangaCellViewModelProtocol>: MvvmCollectionViewCell<VM> {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            titleLabel.rx.text <- viewModel.title
            viewModel.img.bind { [unowned self] url in
                activityIndicator.startAnimating()
                imageView.setImage(url) { [weak self] in
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
    }

}
