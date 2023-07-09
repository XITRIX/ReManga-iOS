//
//  CatalogViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 07.04.2023.
//

import MvvmFoundation
import RxBiBinding
import RxCocoa
import RxSwift
import UIKit

class CatalogViewController<VM: CatalogViewModelProtocol>: BaseViewController<VM> {
    @IBOutlet private var collectionView: UICollectionView!
    private let filterButtonItem = UIBarButtonItem()
    private let orderButtonItem = UIBarButtonItem()

    private var keyboardToken: KeyboardHandler!
    private let searchController = UISearchController()

    private var collectionViewFlowLayout: UICollectionViewFlowLayout { collectionView.collectionViewLayout as! UICollectionViewFlowLayout }

    private lazy var delegates = Delegates(parent: self)
    private lazy var dataSource = UICollectionViewDiffableDataSource<Int, MvvmCellViewModelWrapper<MangaCellViewModel>>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
        itemIdentifier.viewModel.resolveCell(from: collectionView, at: indexPath)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        keyboardToken = KeyboardHandler(collectionView)
        collectionView.delegate = delegates

        navigationItem.largeTitleDisplayMode = .always
        searchController.searchBar.placeholder = "Поиск"
        searchController.delegate = delegates

        orderButtonItem.image = .init(systemName: "arrow.up.arrow.down.circle")

        bind(in: disposeBag) {
            viewModel.searchQuery <- searchController.searchBar.rx.text.throttle(.seconds(1), scheduler: MainScheduler.instance)
            viewModel.items.bind { [unowned self] models in
                applyModels(models)
            }
            collectionView.rx.itemSelected.bind { [unowned self] indexPath in
                let item = dataSource.snapshot().itemIdentifiers(inSection: indexPath.section)[indexPath.item]
                viewModel.showDetails(for: item.viewModel)
                searchController.searchBar.endEditing(true)
            }
            viewModel.isSearchAvailable.bind { [unowned self] available in
                navigationItem.searchController = available ? searchController : nil
                collectionView.setContentOffset(.init(x: 0, y: -200), animated: false)
            }
            viewModel.isFiltersAvailable.bind { [unowned self] available in
                navigationItem.trailingItemGroups = available ? [.fixedGroup(items: [orderButtonItem, filterButtonItem])] : []
            }
            viewModel.sortTypes.bind { [unowned self] types in
                applyOrderMenu(types, viewModel.sortType)
            }

            filterButtonItem.rx.image <- viewModel.filters.map { $0.isEmpty ? .init(systemName: "line.3.horizontal.decrease.circle") : .init(systemName: "line.3.horizontal.decrease.circle.fill") }
            viewModel.showFilters <- filterButtonItem.rx.tap
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
    func applyOrderMenu(_ sorts: [ApiMangaIdModel], _ current: ApiMangaIdModel?) {
        let actions: [UIAction] = sorts.map { sort in
            .init(title: sort.name, state: sort == current ? .on : .off) { [unowned self] _ in
                viewModel.setSortType(sort)
            }
        }
        orderButtonItem.menu = UIMenu(children: actions)
    }
}

private extension CatalogViewController {
    class Delegates: DelegateObject<CatalogViewController>, UICollectionViewDelegateFlowLayout, UISearchControllerDelegate {
        // MARK: - UICollectionViewDelegateFlowLayout
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let columns: Double = collectionView.bounds.width < 600 ? 3 : 5
            let usableWidth = collectionView.bounds.width - collectionView.layoutMargins.left - collectionView.layoutMargins.right
            let itemWidth = ((usableWidth - (columns - 1) * (flowLayout.minimumInteritemSpacing)) / columns).rounded(.down)
            let itemHeight = itemWidth * 1.41 + 42
            return CGSize(width: itemWidth, height: itemHeight)
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if scrollView.contentOffset.y + scrollView.bounds.height > scrollView.contentSize.height - 400 {
                parent.viewModel.loadNext()
            }
        }

        // MARK: - UISearchControllerDelegate
        func willDismissSearchController(_ searchController: UISearchController) {
            parent.viewModel.searchQuery.accept("")
        }
    }
}
