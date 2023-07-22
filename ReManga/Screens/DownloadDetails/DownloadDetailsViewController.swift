//
//  DownloadDetailsViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 08.05.2023.
//

import UIKit
import MvvmFoundation

class DownloadDetailsViewController<VM: DownloadDetailsViewModel>: BaseViewController<VM> {
    @IBOutlet private var collectionView: UICollectionView!
    private lazy var dataSource = MvvmCollectionViewDataSource(collectionView: collectionView)
    private lazy var delegates = Delegates(parent: self)

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        setupCollectionView()

        bind(in: disposeBag) {
            dataSource.applyModels <- viewModel.items
            viewModel.itemSelected <- dataSource.modelSelected
            dataSource.deselectItems <- viewModel.deselectItems
        }
    }
}

private extension DownloadDetailsViewController {
    func setupCollectionView() {
        collectionView.delegate = delegates
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = MvvmCollectionViewLayout(dataSource)

        dataSource.trailingSwipeActionsConfigurationProvider = { [unowned self] indexPath in
            let model = dataSource.snapshot().sectionIdentifiers[indexPath.section].items[indexPath.item]
            guard viewModel.canSelectItem(model) else { return .init() }

            return .init(actions: [.init(style: .destructive, title: "Удалить", handler: { [unowned self] _, _, _ in
                viewModel.deleteModel(model)
            })])
        }
    }
}

// MARK: - Delegates
private extension DownloadDetailsViewController {
    class Delegates: DelegateObject<DownloadDetailsViewController>, UICollectionViewDelegate {
        func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
            let item = parent.dataSource.snapshot().sectionIdentifiers[indexPath.section].items[indexPath.item]
            return parent.viewModel.canSelectItem(item)
        }

        func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
            let item = parent.dataSource.snapshot().sectionIdentifiers[indexPath.section].items[indexPath.item]
            return parent.viewModel.canSelectItem(item)
        }
    }
}
