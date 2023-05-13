//
//  HistoryViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 13.05.2023.
//

import MvvmFoundation
import UIKit

class HistoryViewController<VM: HistoryViewModel>: BaseViewController<VM> {
    @IBOutlet private var collectionView: UICollectionView!
    private lazy var dataSource = MvvmCollectionViewDataSource(collectionView: collectionView)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()

        bind(in: disposeBag) {
            dataSource.applyModels <- viewModel.sections
            viewModel.itemSelected <- dataSource.modelSelected
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        smoothlyDeselectItems(in: collectionView)
    }
}

private extension HistoryViewController {
    func setupCollectionView() {
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = MvvmCollectionViewLayout(dataSource)

        dataSource.trailingSwipeActionsConfigurationProvider = { indexPath in
            .init(actions: [.init(style: .destructive, title: "Удалить", handler: { [unowned self] _, _, _ in
                let item = dataSource.snapshot().sectionIdentifiers[indexPath.section].items[indexPath.item]
                viewModel.removeItem(item)
            })])
        }
    }
}
