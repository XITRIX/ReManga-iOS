//
//  MangaReaderViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 15.04.2023.
//

import UIKit
import MvvmFoundation

class MangaReaderViewController<VM: MangaReaderViewModel>: BaseViewController<VM> {
    @IBOutlet private var collectionView: UICollectionView!
    private var dataSource: DataSource!
    private lazy var delegates = Delegates(parent: self)

    required init(viewModel: VM) {
        super.init(viewModel: viewModel)
        modalPresentationStyle = .fullScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewRespectsSystemMinimumLayoutMargins = false

        setupNavigationItem()
        setupCollectionView()

        bind(in: disposeBag) {
            viewModel.pages.bind { [unowned self] pages in
                applyPages(pages)
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        collectionView.layoutMargins = .zero
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.layoutMargins = .zero
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.layoutMargins = .zero

        let scrollProgress = collectionView.contentOffset.y / (collectionView.contentSize.height - collectionView.layoutMarginsGuide.layoutFrame.height)
        coordinator.animate { [self] context in
            collectionView.setContentOffset(CGPoint(x: 0, y: (collectionView.contentSize.height - collectionView.layoutMarginsGuide.layoutFrame.height) * scrollProgress), animated: false)
        }
    }
}

private extension MangaReaderViewController {
    func applyPages(_ pages: [ApiMangaChapterPageModel]) {
        var snapshot = DataSource.Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(pages, toSection: 0)
        dataSource.apply(snapshot)
    }

    func setupNavigationItem() {
        navigationItem.setLeftBarButton(.init(systemItem: .close, primaryAction: .init(handler: { [weak self] _ in
            self?.dismiss(animated: true)
        })), animated: false)
    }

    func setupCollectionView() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeue(for: indexPath) as MangaReaderPageCell
            cell.setup(with: itemIdentifier)
            return cell
        })

        collectionView.register(type: MangaReaderPageCell.self)
        collectionView.dataSource = dataSource
        collectionView.delegate = delegates
    }
}

private extension MangaReaderViewController {
    class DataSource: UICollectionViewDiffableDataSource<Int, ApiMangaChapterPageModel> { }

    class Delegates: DelegateObject<MangaReaderViewController>, UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            guard let item = parent.dataSource.itemIdentifier(for: indexPath)
            else { return .zero }

            let width = parent.view.layoutMarginsGuide.layoutFrame.width
            let height = (width / item.size.width * item.size.height).rounded(.toNearestOrEven)

            return .init(width: collectionView.frame.width, height: height)
        }
    }
}
