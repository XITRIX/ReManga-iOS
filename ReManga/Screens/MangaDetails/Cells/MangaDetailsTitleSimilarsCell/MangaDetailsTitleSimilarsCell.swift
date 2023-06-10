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

    override var attachCellToContentView: Bool { false }

    override func initSetup() {
        collectionView.delegate = delegates
        collectionView.dataSource = dataSource
        
        backgroundConfiguration = defaultBackgroundConfiguration()
        backgroundConfiguration?.backgroundColor = .clear
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

    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()

        let insets = layoutMargins - safeAreaInsets
        collectionView.contentInset.left = insets.left
        collectionView.contentInset.right = insets.right

        collectionView.horizontalScrollIndicatorInsets.left = insets.left
        collectionView.horizontalScrollIndicatorInsets.right = insets.right

    }

    override func layoutSubviews() {
        super.layoutSubviews()

        /// WORKAROUND: - Collection cells appears with abnormal Y offset for several frames
        /// As workaround just force cell's frame Y to 0 so they will not appear in incorrect place
        for view in collectionView.subviews {
            guard let cell = view as? UICollectionViewCell
            else { continue }

            cell.frame.origin.y = 0
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
