//
//  ProfileDetailsButtonCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 06.05.2023.
//

import UIKit
import MvvmFoundation

class ProfileDetailsButtonCell<VM: ProfileDetailsButtonViewModel>: MvvmCollectionViewListCell<VM> {
    @IBOutlet var label: UILabel!

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            label.rx.text <- viewModel.title
            label.rx.textColor <- viewModel.style.map { $0.textColor }
        }
    }

}

extension ProfileDetailsButtonViewModel.Style {
    var textColor: UIColor {
        switch self {
        case .normal:
            return .tintColor
        case .destructive:
            return .systemRed
        }
    }
}
