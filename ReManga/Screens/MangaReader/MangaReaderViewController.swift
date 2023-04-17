//
//  MangaReaderViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 15.04.2023.
//

import UIKit
import RxSwift
import RxRelay
import MvvmFoundation

class MangaReaderViewController<VM: MangaReaderViewModel>: BaseViewController<VM> {
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var navigationBar: UINavigationBar!
    @IBOutlet private var toolBar: UIToolbar!
    @IBOutlet private var headerView: UIView!
    @IBOutlet private var navigationBarHiddenConstraint: NSLayoutConstraint!
    @IBOutlet private var toolBarHiddenConstraint: NSLayoutConstraint!

    @IBOutlet private var previousButton: UIButton!
    @IBOutlet private var nextButton: UIButton!
    @IBOutlet private var headerTitleButton: UIButton!

    @IBOutlet private var likeButton: UIButton!

    private var dataSource: DataSource!
    private lazy var delegates = Delegates(parent: self)

    var currentDisposeBag = DisposeBag()

    private var isNavigationBarVisible: Bool { !navigationBarHiddenConstraint.isActive && !toolBarHiddenConstraint.isActive }

    required init(viewModel: VM) {
        super.init(viewModel: viewModel)
        modalPresentationStyle = .fullScreen
    }

    override func attachOverlayViewController(_ viewController: UIViewController) {
        addChild(viewController)
        viewController.view.frame = view.bounds
        view.insertSubview(viewController.view, aboveSubview: collectionView)
        viewController.didMove(toParent: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewRespectsSystemMinimumLayoutMargins = false

        setupNavigationItem()
        setupCollectionView()

        bind(in: disposeBag) {
            viewModel.current.bind { [unowned self] current in
                currentDisposeBag = DisposeBag()
                bindToCurrent(current)
            }

            previousButton.rx.isEnabled <- viewModel.previousActionAvailable
            nextButton.rx.isEnabled <- viewModel.nextActionAvailable

            viewModel.gotoPreviousChapter <- previousButton.rx.tap
            viewModel.gotoNextChapter <- nextButton.rx.tap
            headerTitleButton.rx.title() <- viewModel.chapterName

            viewModel.pages.bind { [unowned self] pages in
                applyPages(pages)
                applyMenu()
            }

            viewModel.toggleLike <- likeButton.rx.tap
        }

        collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizer(_:))))
    }

    func bindToCurrent(_ current: MangaDetailsChapterViewModel?) {
        guard let current else { return }
        bind(in: currentDisposeBag) {
            Observable.combineLatest(current.isLiked, current.likes).bind { [unowned self] (isLiked, likes) in
                let like = isLiked == true
                likeButton.configuration = like ? .filled() : .tinted()
                likeButton.configuration?.buttonSize = .mini
                likeButton.configuration?.image = like ? .init(systemName: "heart.fill") : .init(systemName: "heart")
                likeButton.configuration?.title = " \(likes)"
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
            collectionView.reloadData()
            collectionView.setContentOffset(CGPoint(x: 0, y: (collectionView.contentSize.height - collectionView.layoutMarginsGuide.layoutFrame.height) * scrollProgress), animated: false)
        }
    }

    @objc private func tapGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        if couldHideNavigation {
            setNavigationBarHidden(isNavigationBarVisible)
        }
    }

    override var prefersStatusBarHidden: Bool {
        !isNavigationBarVisible
    }

    override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()

        let top = navigationBar.frame.height
        let bottom = toolBar.frame.height

        collectionView.contentInset.top = top
        collectionView.verticalScrollIndicatorInsets.top = top

        collectionView.contentInset.bottom = bottom
        collectionView.verticalScrollIndicatorInsets.bottom = bottom
    }
}

private extension MangaReaderViewController {
    func applyMenu() {
        let test: [UIAction] = viewModel.chapters.value.enumerated().map { chapter in
            let readed = chapter.element.isReaded.value ? "" : " •"
            return UIAction(title: "Том \(chapter.element.tome.value) \(chapter.element.chapter.value)" + readed, state: chapter.offset == viewModel.currentChapter.value ? .on : .off) { [weak self] _ in
                self?.viewModel.currentChapter.accept(chapter.offset)
            }
        }
        headerTitleButton.menu = UIMenu(options: [.singleSelection], children: test)
    }

    func applyPages(_ pages: [MvvmViewModel]) {
        var snapshot = DataSource.Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(pages.map { .init(viewModel: $0) }, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func setupNavigationItem() {
        navigationBar.delegate = delegates
        navigationBar.setItems([navigationItem], animated: false)
        navigationItem.titleView = headerView
        navigationItem.setLeftBarButton(.init(systemItem: .close, primaryAction: .init(handler: { [weak self] _ in
            self?.dismiss(animated: true)
        })), animated: false)
    }

    func setupCollectionView() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            itemIdentifier.viewModel.resolveCell(from: collectionView, at: indexPath)
        })

//        collectionView.register(type: MangaReaderLoadNextCell.self)
//        collectionView.register(type: MangaReaderPageCell.self)
        collectionView.dataSource = dataSource
        collectionView.delegate = delegates
    }

    func setNavigationBarHidden(_ hidden: Bool) {
        UIView.animate(withDuration: 0.3) { [self] in
            navigationBarHiddenConstraint.isActive = hidden
            toolBarHiddenConstraint.isActive = hidden
            view.layoutIfNeeded()
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    var couldHideNavigation: Bool {
        let offset = collectionView.contentOffset.y
        let max = collectionView.contentSize.height - collectionView.frame.height
//        print(max - offset)
        return offset > 0 && max - offset > 0
    }
}

private extension MangaReaderViewController {
    class DataSource: UICollectionViewDiffableDataSource<Int, MvvmCellViewModelWrapper<MvvmViewModel>> { }

    class Delegates: DelegateObject<MangaReaderViewController>, UICollectionViewDelegateFlowLayout, UINavigationBarDelegate {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if let item = parent.dataSource.itemIdentifier(for: indexPath)?.viewModel as? MangaReaderPageViewModel {

                let width = parent.view.layoutMarginsGuide.layoutFrame.width
                let height = (width / item.imageSize.value.width * item.imageSize.value.height).rounded(.toNearestOrEven)

                return .init(width: collectionView.frame.width, height: height)
            }

            if parent.dataSource.itemIdentifier(for: indexPath)?.viewModel is MangaReaderLoadNextViewModel {
                return .init(width: collectionView.frame.width, height: 50)
            }

//            if parent.dataSource.itemIdentifier(for: indexPath)?.viewModel is MangaReaderLoadNextViewModel {
//                return .init(width: collectionView.frame.width, height: collectionView.layoutMarginsGuide.layoutFrame.height - parent.toolBar.frame.height - parent.navigationBar.frame.height)
//            }

            return .zero
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            setNavigationVisibility(scrollView)
        }

        func setNavigationVisibility(_ scrollView: UIScrollView) {
            let velocity = scrollView.panGestureRecognizer.velocity(in: parent.view).y
            let couldHide = parent.couldHideNavigation
            if !couldHide || velocity > 500 {
                parent.setNavigationBarHidden(false)
            } else if velocity < -500 && couldHide {
                parent.setNavigationBarHidden(true)
            }
        }

        // MARK: - UINavigationBarDelegate
        func position(for bar: UIBarPositioning) -> UIBarPosition {
            .topAttached
        }
    }
}
