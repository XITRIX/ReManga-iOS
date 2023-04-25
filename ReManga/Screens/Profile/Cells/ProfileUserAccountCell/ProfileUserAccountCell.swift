//
//  ProfileUserAccountCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 25.04.2023.
//

import UIKit
import MvvmFoundation

class ProfileUserAccountCell<VM: ProfileUserAccountViewModel>: MvvmCollectionViewListCell<VM> {

    override func setup(with viewModel: VM) {
        var confing = defaultContentConfiguration()
        confing.text = "Залогинься плз"
        contentConfiguration = confing

        accessories = [.disclosureIndicator()]
    }

}
