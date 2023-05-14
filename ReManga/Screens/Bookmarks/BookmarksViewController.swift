//
//  BookmarksViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 14.05.2023.
//

import MvvmFoundation
import UIKit

class BookmarksViewController<VM: BookmarksViewModel>: BaseViewController<VM> {
    @IBOutlet private var collectionView: UICollectionView!

    private var collectionViewFlowLayout: UICollectionViewFlowLayout { collectionView.collectionViewLayout as! UICollectionViewFlowLayout }

    private lazy var delegates = Delegates(parent: self)
    private lazy var dataSource = UICollectionViewDiffableDataSource<Int, MvvmCellViewModelWrapper<MangaCellViewModel>>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
        itemIdentifier.viewModel.resolveCell(from: collectionView, at: indexPath)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = dataSource
        collectionView.delegate = delegates

        bind(in: disposeBag) {
            viewModel.items.bind { [unowned self] models in
                applyModels(models)
            }

            collectionView.rx.itemSelected.bind { [unowned self] indexPath in
                let item = dataSource.snapshot().itemIdentifiers(inSection: indexPath.section)[indexPath.item]
                viewModel.showDetails(for: item.viewModel)
            }
        }
    }

    override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
        collectionViewFlowLayout.minimumInteritemSpacing = systemMinimumLayoutMargins.leading
    }
}

private extension BookmarksViewController {
    func applyModels(_ models: [MangaCellViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, MvvmCellViewModelWrapper<MangaCellViewModel>>()
        snapshot.appendSections([0])
        snapshot.appendItems(models.map { .init(viewModel: $0) })
        dataSource.apply(snapshot)
    }
}

private extension BookmarksViewController {
    class Delegates: DelegateObject<BookmarksViewController>, UICollectionViewDelegateFlowLayout {
        // MARK: - UICollectionViewDelegateFlowLayout
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let columns: Double = collectionView.bounds.width < 600 ? 3 : 5
            let usableWidth = collectionView.bounds.width - collectionView.layoutMargins.left - collectionView.layoutMargins.right
            let itemWidth = ((usableWidth - (columns - 1) * (flowLayout.minimumInteritemSpacing)) / columns).rounded(.down)
            let itemHeight = itemWidth * 1.41 + 42
            return CGSize(width: itemWidth, height: itemHeight)
        }
    }
}
