//
//  MangaDetailsTitleSimilarsCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 03.06.2023.
//

import MvvmFoundation
import UIKit

class MangaDetailsTitleSimilarsCell<VM: MangaDetailsTitleSimilarsViewModel>: MvvmCollectionViewListCell<VM> {
    @IBOutlet private var collectionView: UICollectionView!
    private lazy var delegates = Delegates(parent: self)
    private lazy var dataSource = UICollectionViewDiffableDataSource<Int, MvvmCellViewModelWrapper<MvvmViewModel>>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
        itemIdentifier.viewModel.resolveCell(from: collectionView, at: indexPath)
    }

    override func initSetup() {
        collectionView.dataSource = dataSource
        collectionView.delegate = delegates
    }

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            delegates.updateSimilars <- viewModel.similars

            collectionView.rx.itemSelected.bind { [unowned viewModel] indexPath in
                let items = viewModel.similars.value[indexPath.item]
                viewModel.selected.accept(items.id)
            }
        }
    }
}

extension MangaDetailsTitleSimilarsCell {
    class Delegates: DelegateObject<MangaDetailsTitleSimilarsCell>, UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let itemHeight: Double = 180
            let itemWidth = (itemHeight - 42) / 1.41
            return CGSize(width: itemWidth, height: itemHeight)
        }

        func updateSimilars(_ similars: [ApiMangaModel]) {
            var snapshot = NSDiffableDataSourceSnapshot<Int, MvvmCellViewModelWrapper<MvvmViewModel>>()
            snapshot.appendSections([0])
            snapshot.appendItems(similars.map { .init(viewModel: MangaCellViewModel(with: $0)) })
            parent.dataSource.apply(snapshot)
        }
    }
}
