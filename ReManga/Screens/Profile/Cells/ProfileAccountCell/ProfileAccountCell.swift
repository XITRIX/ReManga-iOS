//
//  ProfileAccountCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 24.04.2023.
//

import UIKit
import MvvmFoundation

class ProfileAccountCell<VM: ProfileAccountViewModel>: MvvmCollectionViewListCell<VM> {
    @IBOutlet private var image: UIImageView!
    @IBOutlet private var title: UILabel!
    @IBOutlet private var subtitle: UILabel!

    override func initSetup() {
        var conf = defaultBackgroundConfiguration()
        conf.backgroundColor = .secondarySystemGroupedBackground
        backgroundConfiguration = conf
    }

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            image.rx.imageUrl() <- viewModel.image
            title.rx.text <- viewModel.title
            subtitle.rx.text <- viewModel.subtitle
        }
    }

}
