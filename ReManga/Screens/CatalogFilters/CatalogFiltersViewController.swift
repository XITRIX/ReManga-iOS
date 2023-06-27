//
//  CatalogFiltersViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 10.06.2023.
//

import MvvmFoundation
import RxBiBinding
import RxSwift
import UIKit

class CatalogFiltersViewController<VM: CatalogFiltersViewModel>: BaseViewController<VM> {
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var clearButton: UIButton!

    private lazy var dataSource = MvvmCollectionViewDataSource(collectionView: collectionView)
    private let dismissButtonItem = UIBarButtonItem(systemItem: .close)

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.trailingItemGroups = [.fixedGroup(items: [dismissButtonItem])]

        #if !os(xrOS)
        if let sheet = navigationController?.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        #endif

        collectionView.dataSource = dataSource
        let layout = MvvmCollectionViewLayout(dataSource, headerMode: .firstItemInSection)
        collectionView.collectionViewLayout = layout
        collectionView.allowsMultipleSelection = true
        
        bind(in: disposeBag) {
            viewModel.dismiss <- dismissButtonItem.rx.tap
            viewModel.selectedItems <- collectionView.rx.indexPathsForSelectedItems

            clearButton.rx.isHidden <- viewModel.filters.map { $0.isEmpty }
            viewModel.clearFilters <- clearButton.rx.tap

            viewModel.sections.bind { [unowned self] sections in
                apply(sections)
            }

            viewModel.deselectAll.bind { [unowned self] _ in
                deselectAll()
            }
        }

        dataSource.sectionSnapshotHandlers.willExpandItem = { [unowned self] item in
            guard let section = item.viewModel as? CatalogFilterHeaderViewModel,
                  let index = viewModel.sections.value.firstIndex(where: { section.section == $0 })
            else { return }

            DispatchQueue.main.async { [self] in
                for indexPath in collectionView.indexPathsForSelectedItems ?? [] {
                    guard indexPath.section == index else { continue }
                    collectionView.deselectItem(at: indexPath, animated: false)
                }

                for indexPath in viewModel.selectedItems.value {
                    guard indexPath.section == index else { continue }
                    collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                }
            }
        }
    }

    func apply(_ sections: [MvvmCollectionSectionModel]) {
        for section in sections {
            var snapshot = NSDiffableDataSourceSectionSnapshot<MvvmCellViewModelWrapper<MvvmViewModel>>()
            let header = CatalogFilterHeaderViewModel(with: section)
            snapshot.append([.init(viewModel: header)])
            snapshot.append(section.items.map { .init(viewModel: $0) }, to: .init(viewModel: header))
            dataSource.apply(snapshot, to: section)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.contentInset.bottom = clearButton.bounds.height + 16
    }

    let headerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) {
        _, _, _ in
    }
}

private extension CatalogFiltersViewController {
    func applySelection() {
        for indexPath in viewModel.selectedItems.value {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
    }

    func deselectAll() {
        for indexPath in collectionView.indexPathsForSelectedItems ?? [] {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
}
