//
//  BookmarksViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 14.05.2023.
//

import MvvmFoundation
import RxSwift
import UIKit

class BookmarksViewController<VM: BookmarksViewModel>: BaseViewController<VM> {
    @IBOutlet private var collectionView: UICollectionView!

    private var flowLayout: UICollectionViewFlowLayout { collectionView.collectionViewLayout as! UICollectionViewFlowLayout }
    private let filterButton = UIBarButtonItem(title: nil, image: nil, target: nil, action: nil)
    private var collectionViewFlowLayout: UICollectionViewFlowLayout { collectionView.collectionViewLayout as! UICollectionViewFlowLayout }

    private lazy var delegates = Delegates(parent: self)
    private lazy var dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
        itemIdentifier.viewModel.resolveCell(from: collectionView, at: indexPath)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        collectionView.register(BookmarksFilterHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BookmarksFilterHeaderCell.reusableId)

        flowLayout.sectionHeadersPinToVisibleBounds = true
        dataSource.supplementaryViewProvider = supplementaryViewProvider
        collectionView.verticalScrollIndicatorInsets.top = 44
        collectionView.dataSource = dataSource
        collectionView.delegate = delegates
        collectionView.layoutMargins = .zero

        navigationItem.trailingItemGroups = [.fixedGroup(items: [filterButton])]

        bind(in: disposeBag) {
            viewModel.items.bind { [unowned self] models in
                applyModels(models)
            }

            collectionView.rx.itemSelected.bind { [unowned self] indexPath in
                let item = dataSource.snapshot().itemIdentifiers(inSection: indexPath.section)[indexPath.item]
                viewModel.showDetails(for: item.viewModel)
            }

            filterButton.rx.isHidden <- viewModel.isFilterButtonAvailable.inverted

            // TODO: Not the best variant of status filter
//            viewModel.isFilterButtonAvailable.bind { [unowned self] available in
//                flowLayout.headerReferenceSize = available ? .init(width: 400, height: 44) : .zero
//            }

            filterButton.rx.image <- viewModel.selectedBookmarkType.map { bookmarkType in
                bookmarkType == nil ? .init(systemName: "line.3.horizontal.decrease.circle") : .init(systemName: "line.3.horizontal.decrease.circle.fill")
            }

            delegates.setupFilterSelectionMenu <- Observable.combineLatest(viewModel.bookmarkTypes, viewModel.selectedBookmarkType)
        }
    }

    override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
        collectionViewFlowLayout.minimumInteritemSpacing = systemMinimumLayoutMargins.leading
    }
}

private extension BookmarksViewController {
    func applyModels(_ models: [MangaCellViewModel]) {
        var snapshot = DataSource.Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(models.unique.map { .init(viewModel: $0) })
        dataSource.apply(snapshot)
    }

    func supplementaryViewProvider(_ collectionView: UICollectionView, _ elementKind: String, _ indexPath: IndexPath) -> UICollectionReusableView? {
        let cell = viewModel.filterViewModel.resolveCell(from: collectionView, at: indexPath, with: UICollectionView.elementKindSectionHeader)
        return cell
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

        // MARK: - Binding functions
        func setupFilterSelectionMenu(from models: [ApiMangaBookmarkModel], with selectedModel: ApiMangaBookmarkModel?) {
            var actions = [UIAction(title: "Все", state: selectedModel == nil ? .on : .off) { [weak self] _ in self?.parent.viewModel.selectedBookmarkType.accept(nil) }]

            for model in models {
                actions.append(.init(title: model.name, state: selectedModel == model ? .on : .off) { [weak self] _ in self?.parent.viewModel.selectedBookmarkType.accept(model) })
            }

            parent.filterButton.menu = .init(children: actions)
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.viewModel.filterViewModel.blurAlpha.accept(getNavBarAlpha() ?? 1)
        }

        func getNavBarAlpha() -> CGFloat? {
            // Try to get navbar backlayer
            guard let navBar = parent.navigationController?.navigationBar.subviews.first?.subviews.first
            else { return nil }

            return navBar.alpha
        }
    }
}

private extension BookmarksViewController {
    class DataSource: UICollectionViewDiffableDataSource<Int, MvvmCellViewModelWrapper<MangaCellViewModel>> {}
}
