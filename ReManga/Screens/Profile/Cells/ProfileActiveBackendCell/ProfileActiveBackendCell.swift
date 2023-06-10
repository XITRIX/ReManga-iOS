//
//  ProfileActiveBackendCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 10.05.2023.
//

import UIKit
import MvvmFoundation

class ProfileActiveBackendCell<VM: ProfileActiveBackendViewModel>: MvvmCollectionViewListCell<VM> {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var detailsLabel: UILabel!

    override func setup(with viewModel: VM) {
        setupMenu(with: viewModel.backends)

        bind(in: disposeBag) {
            titleLabel.rx.text <- viewModel.title
            detailsLabel.rx.text <- viewModel.detailsTitle
        }
    }
}

private extension ProfileActiveBackendCell {
    func setupMenu(with backends: [ContainerKey.Backend]) {
        let items = backends.map({ backend in
            UIAction(title: backend.title) { [unowned self] _ in
                viewModel.selectBackend(backend)
            }
        })
        accessories = [.popUpMenu(UIMenu(children: items), options: .init(tintColor: .tintColor))]
    }
}
