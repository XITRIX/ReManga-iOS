//
//  CatalogViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 07.04.2023.
//

import UIKit
import MvvmFoundation
import RxSwift
import RxCocoa
import RxBiBinding

class CatalogViewController<VM: CatalogViewModelProtocol>: BaseViewController<VM> {
    @IBOutlet private var collectionView: UICollectionView!
    private var keyboardToken: KeyboardHandler!

    private var collectionViewFlowLayout: UICollectionViewFlowLayout {
        get { collectionView.collectionViewLayout as! UICollectionViewFlowLayout }
    }

    private lazy var delegates = Delegates(parent: self)
    private lazy var dataSource = UICollectionViewDiffableDataSource<Int, MvvmCellViewModelWrapper<MangaCellViewModel>>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
        itemIdentifier.viewModel.resolveCell(from: collectionView, at: indexPath)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        keyboardToken = KeyboardHandler(collectionView)
        collectionView.delegate = delegates
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController

        bind(in: disposeBag) {
            viewModel.searchQuery <- searchController.searchBar.rx.text.throttle(.seconds(1), scheduler: MainScheduler.instance)
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

    private func applyModels(_ models: [MangaCellViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, MvvmCellViewModelWrapper<MangaCellViewModel>>()
        snapshot.appendSections([0])
        snapshot.appendItems(models.map { .init(viewModel: $0) })
        dataSource.apply(snapshot)
    }
}

private extension CatalogViewController {
    class Delegates: DelegateObject<CatalogViewController>, UICollectionViewDelegateFlowLayout, UISearchControllerDelegate {
        // MARK: - UICollectionViewDelegateFlowLayout
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let columns: Double = collectionView.bounds.width < 600 ? 3 : 5
            let usableWidth = collectionView.bounds.width - collectionView.layoutMargins.left - collectionView.layoutMargins.right
            let itemWidth = (usableWidth - (columns - 1) * (flowLayout.minimumInteritemSpacing)) / columns
            let itemHeight = itemWidth * 1.41 + 42
            return CGSize(width: itemWidth, height: itemHeight)
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if scrollView.contentOffset.y + scrollView.bounds.height > scrollView.contentSize.height - 400 {
                parent.viewModel.loadNext()
            }
        }

        // MARK: - UISearchControllerDelegate
    }
}
