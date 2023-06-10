//
//  CatalogFiltersViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 10.06.2023.
//

import UIKit
import MvvmFoundation

class CatalogFiltersViewController<VM: CatalogFiltersViewModel>: BaseViewController<VM> {
    @IBOutlet private var collectionView: UICollectionView!
    private lazy var dataSource = MvvmCollectionViewDataSource(collectionView: collectionView)
    private let dismissButtonItem = UIBarButtonItem(systemItem: .close)

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.trailingItemGroups = [.fixedGroup(items: [dismissButtonItem])]

        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = MvvmCollectionViewLayout(dataSource)
//        collectionView.isEditing = true
        collectionView.allowsMultipleSelection = true

        bind(in: disposeBag) {
            viewModel.dismiss <- dismissButtonItem.rx.tap
            viewModel.selectedItems <-> collectionView.rx.indexPathsForSelectedItems

            viewModel.sections.bind { [unowned self] sections in
                dataSource.applyModels(sections) { [self] in
                    viewModel.applySelection(with: collectionView.indexPathsForSelectedItems ?? [])
                }
            }
        }
    }
}
