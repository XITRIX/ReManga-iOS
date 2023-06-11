//
//  CatalogFilterHeaderCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 11.06.2023.
//

import UIKit
import MvvmFoundation

class CatalogFilterHeaderCell<VM: CatalogFilterHeaderViewModel>: MvvmCollectionViewListCell<VM> {
    private var listContentConfiguration: UIListContentConfiguration {
        get { contentConfiguration as? UIListContentConfiguration ?? defaultContentConfiguration() }
        set { contentConfiguration = newValue }
    }

    override func initSetup() {
        let disclosureOptions = UICellAccessory.OutlineDisclosureOptions(style: .header)
        accessories = [.outlineDisclosure(options: disclosureOptions)]
    }

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            viewModel.title.bind { [unowned self] text in
                listContentConfiguration.text = text
            }
        }
    }

}
