//
//  CatalogFilterItemCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 10.06.2023.
//

import UIKit
import MvvmFoundation

class CatalogFilterItemCell<VM: CatalogFilterItemViewModel>: MvvmCollectionViewListCell<VM> {
    @IBOutlet private var title: UILabel!

    var listContentConfiguration: UIListContentConfiguration {
        get { contentConfiguration as? UIListContentConfiguration ?? defaultContentConfiguration() }
        set { contentConfiguration = newValue }
    }

    override func initSetup() {
        accessories = [.multiselect(displayed: .always)]
//        accessories = [.popUpMenu(<#T##menu: UIMenu##UIMenu#>)]
//        var content = defaultContentConfiguration()
//        content.text
//        contentConfiguration =
    }

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
//            title.rx.text <- viewModel.title
            viewModel.title.bind { [unowned self] text in
                listContentConfiguration.text = text
            }
        }
    }
}
