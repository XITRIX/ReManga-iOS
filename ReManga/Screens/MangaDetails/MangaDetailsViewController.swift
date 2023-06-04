//
//  MangaDetailsViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 13.04.2023.
//

import MarqueeLabel
import MvvmFoundation
import RxSwift
import UIKit

class MangaDetailsViewController<VM: MangaDetailsViewModel>: BaseViewController<VM> {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var headerCapView: UIView!

    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var imageViewHolder: UIView!
    @IBOutlet private var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var collectionView: UICollectionView!

    @IBOutlet private var navTitleView: UIView!
    @IBOutlet private var navTitleLabel: MarqueeLabel!

    @IBOutlet private var bookmarkButton: UIButton!
    @IBOutlet private var continueButton: UIButton!
    @IBOutlet private var continueButtonLoadingIndicator: UIActivityIndicatorView!

    private lazy var dataSource = MvvmCollectionViewDataSource(collectionView: collectionView)
    private lazy var delegates = Delegates(parent: self)

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.overrideUserInterfaceStyle = .dark
        subtitleLabel.overrideUserInterfaceStyle = .dark

        setupCap()
        setupNavigationAppearance()
        setupCollectionView()

        bind(in: disposeBag) {
            collectionView.rx.isEditing <- viewModel.downloadingTableState
            navTitleLabel.rx.text <- viewModel.title
            viewModel.itemSelected <- collectionView.rx.itemSelected
            viewModel.selectedItems <-> collectionView.rx.indexPathsForSelectedItems
            imageView.rx.imageUrl(with: activityIndicator) <- viewModel.image
            viewModel.items.bind { [unowned self] models in
                dataSource.applyModels(models) { [weak self] in
                    self?.updateCollectionViewInset()
                }
            }
            titleLabel.rx.text <- viewModel.title
            subtitleLabel.rx.text <- viewModel.detail

            bookmarkButton.rx.isHidden <- viewModel.bookmarks.map { $0.isEmpty }
            bookmarkButton.rx.image() <- viewModel.currentBookmark.map { $0 == nil ? .init(systemName: "bookmark") : .init(systemName: "bookmark.fill") }
            Observable.combineLatest(viewModel.bookmarks, viewModel.currentBookmark).bind { [unowned self] bookmarks, current in
                applyBookmarksMenu(bookmarks, current)
            }

            viewModel.continueReading <- continueButton.rx.tap
            continueButton.rx.image() <- viewModel.$isChaptersFetchingDone.map { $0 ? .init(systemName: "play.fill") : nil }
            continueButtonLoadingIndicator.rx.isAnimating <- viewModel.$isChaptersFetchingDone.map { !$0 }
        }
    }

    deinit {
        print("DETAILS DEINITED!!!!!!!!!!!")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selected = collectionView.indexPathsForSelectedItems?.first {
            collectionView.deselectItem(at: selected, animated: true)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        /// WORKAROUND: - Setting window.tintColor cause some colors in viewController lose
        /// their userInterfaceLevel context on viewWillDisappear,
        /// so we reset it manually
        setupElevationContext()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCollectionViewInset()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        let contentOffset = collectionView.contentOffset
        coordinator.animate { [self] _ in
            collectionView.setContentOffset(contentOffset, animated: false)
            delegates.updateBackgorundImageSize(with: collectionView)
        }
    }
}

private extension MangaDetailsViewController {
    func applyBookmarksMenu(_ bookmarks: [ApiMangaBookmarkModel], _ current: ApiMangaBookmarkModel?) {
        let actions: [UIAction] = bookmarks.map { bookmark in
            .init(title: bookmark.name, state: bookmark == current ? .on : .off) { [unowned self] _ in
                viewModel.selectBookmark(bookmark)
            }
        }
        bookmarkButton.menu = UIMenu(children: actions)
    }

    func updateCollectionViewInset() {
        viewModel.insetVM.height.accept(contentOffset)
    }

    func setupCap() {
        headerCapView.layer.cornerRadius = 16
        headerCapView.layer.cornerCurve = .continuous
        headerCapView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    func setupElevationContext() {
        navigationController?.setOverrideTraitCollection(UITraitCollection(userInterfaceLevel: .elevated), forChild: self)
    }

    func setupNavigationAppearance() {
        setupElevationContext()
        navigationItem.titleView = navTitleView

        let scrollButtonsAppearance = UIBarButtonItemAppearance()
        scrollButtonsAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]

        let scrollAppearance = UINavigationBarAppearance()
        scrollAppearance.configureWithTransparentBackground()
        scrollAppearance.buttonAppearance = scrollButtonsAppearance
        scrollAppearance.titleTextAttributes = [.foregroundColor: UIColor.clear]
        scrollAppearance.setBackIndicatorImage(.init(systemName: "chevron.backward.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal).with(size: .init(width: 30, height: 30)), transitionMaskImage: .init(systemName: "chevron.backward.circle.fill"))
        navigationItem.scrollEdgeAppearance = scrollAppearance

        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        navigationItem.standardAppearance = appearance

        navigationItem.largeTitleDisplayMode = .never
    }

    func setupCollectionView() {
        collectionView.backgroundView = imageViewHolder
        collectionView.delegate = delegates

        collectionView.allowsMultipleSelectionDuringEditing = true

        collectionView.collectionViewLayout = MvvmCollectionViewLayout(dataSource)
        collectionView.dataSource = dataSource
    }

    var contentOffset: Double {
        min(collectionView.bounds.width * 1.41, collectionView.layoutMarginsGuide.layoutFrame.height * 3.0 / 4.0)
    }
}

private extension MangaDetailsViewController {
    class Delegates: DelegateObject<MangaDetailsViewController>, UICollectionViewDelegate {
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            updateBackgorundImageSize(with: scrollView)
        }

        func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
            let model = parent.dataSource.snapshot().sectionIdentifiers[indexPath.section].items[indexPath.item]
            return parent.viewModel.shouldSelectModel(model)
        }

        func updateBackgorundImageSize(with scrollView: UIScrollView) {
            parent.imageViewHeightConstraint.constant = -scrollView.contentOffset.y + parent.contentOffset

            let offset = scrollView.contentOffset.y + scrollView.contentInset.top
            let alpha = max(0, min(offset / 8, 1))
            parent.navTitleLabel.isHidden = alpha <= 0
            parent.navTitleLabel.alpha = alpha

            if scrollView.contentOffset.y + scrollView.bounds.height > scrollView.contentSize.height - 400 {
                parent.viewModel.bottomReached()
            }
        }
    }
}
