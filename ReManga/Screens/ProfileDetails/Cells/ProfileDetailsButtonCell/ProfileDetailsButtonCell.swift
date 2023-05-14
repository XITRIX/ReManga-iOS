//
//  ProfileDetailsButtonCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 06.05.2023.
//

import UIKit
import MvvmFoundation

class ProfileDetailsButtonCell<VM: ProfileDetailsButtonViewModel>: MvvmCollectionViewListCell<VM> {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var label: UILabel!

    override func initSetup() {
        label.textColor = .tintColor
    }

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            rx.tintColor <- viewModel.style.map { $0.color }
            label.rx.text <- viewModel.title
            imageView.rx.setImageWithVisibility() <- viewModel.image
            viewModel.disclosure.bind { [unowned self] disclosure in
                var accessories = accessories.filter { $0.accessoryType != .disclosureIndicator }
                if disclosure { accessories.append(.disclosureIndicator()) }
                self.accessories = accessories
            }
        }
    }

}

extension ProfileDetailsButtonViewModel.Style {
    var color: UIColor {
        switch self {
        case .normal:
            return .label
        case .tinted:
            return .tintColor
        case .destructive:
            return .systemRed
        }
    }
}
