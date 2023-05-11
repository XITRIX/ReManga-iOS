//
//  TestViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 19.04.2023.
//

import MvvmFoundation
import RxSwift
import UIKit

class MangaReaderViewController<VM: MangaReaderViewModelProtocol>: BaseViewController<VM> {
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var navigationBar: UINavigationBar!
    @IBOutlet private var toolBar: UIToolbar!
    @IBOutlet private var navHeaderView: UIView!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var commentsButton: UIButton!
    @IBOutlet private var bookmarkButton: UIButton!

    @IBOutlet private var previousButton: UIButton!
    @IBOutlet private var nextButton: UIButton!
    @IBOutlet private var headerTitleButton: UIButton!

    private lazy var delegates = Delegates(parent: self)

    private var currentDisposeBag = DisposeBag()

    lazy var navigationBarHiddenConstraint: NSLayoutConstraint = { navigationBar.bottomAnchor.constraint(equalTo: view.topAnchor) }()
    lazy var toolBarHiddenConstraint: NSLayoutConstraint = { toolBar.topAnchor.constraint(equalTo: view.bottomAnchor) }()

    private lazy var dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
        itemIdentifier.viewModel.resolveCell(from: collectionView, at: indexPath)
    }

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

    override func stateDidChange(_ state: ViewModelState) {
        guard case let .error(error, task) = state,
           let error = error as? ApiMangaError,
           case let .needPayment(vm, api) = error
        else { return super.stateDidChange(state) }

        overlayViewController = MangaPaymentViewModel.resolveVC(with: .init(mangaVM: vm, completion: task, api: api))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        toolBarHiddenConstraint.isActive = !viewModel.isActionsAvailable.value

        viewRespectsSystemMinimumLayoutMargins = false
        navigationItem.setLeftBarButton(.init(barButtonSystemItem: .close, target: self, action: #selector(closeAction)), animated: false)
        navigationItem.titleView = navHeaderView

        toolBar.delegate = delegates
        navigationBar.delegate = delegates
        navigationBar.setItems([navigationItem], animated: false)

        setupCollectionView()

        collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleBarsHidden)))

        bind(in: disposeBag) {
            viewModel.current.bind { [unowned self] current in
                currentDisposeBag = DisposeBag()
                bindToCurrent(current)
            }
            
            viewModel.pages.bind { [unowned self] models in
                applyModels(models)
                applyMenu()
            }

            previousButton.rx.isEnabled <- viewModel.previousActionAvailable
            nextButton.rx.isEnabled <- viewModel.nextActionAvailable

            viewModel.gotoPreviousChapter <- previousButton.rx.tap
            viewModel.gotoNextChapter <- nextButton.rx.tap
            headerTitleButton.rx.title() <- viewModel.chapterName

            viewModel.toggleLike <- likeButton.rx.tap

            viewModel.currentBookmark.bind { [unowned self] bookmark in
                bookmarkButton.configuration = bookmark == nil ? bookmarkButton.configuration?.toTinted() : bookmarkButton.configuration?.toFilled()
                bookmarkButton.setImage( bookmark == nil ? .init(systemName: "bookmark") : .init(systemName: "bookmark.fill"), for: .normal)
            }

            Observable.combineLatest(viewModel.bookmarks, viewModel.currentBookmark).bind { [unowned self] bookmarks, currentBookmark in
                applyBookmarksMenu(bookmarks, currentBookmark)
            }

            commentsButton.rx.title() <- viewModel.commentsCount.map { "Коментарии \($0)" }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        collectionView.contentInset.top = navigationBar.frame.height
        collectionView.contentInset.bottom = toolBar.frame.height

        collectionView.verticalScrollIndicatorInsets.top = collectionView.contentInset.top
        collectionView.verticalScrollIndicatorInsets.bottom = collectionView.contentInset.bottom
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.layoutMargins = .zero

        let scrollProgress = collectionView.contentOffset.y / (collectionView.contentSize.height - collectionView.layoutMarginsGuide.layoutFrame.height)
        coordinator.animate { [self] _ in
//            collectionView.reloadData()
            collectionView.setContentOffset(CGPoint(x: 0, y: (collectionView.contentSize.height - collectionView.layoutMarginsGuide.layoutFrame.height) * scrollProgress), animated: false)
        }
    }

    override var prefersStatusBarHidden: Bool {
        isBarsHidden
    }

    @objc private func closeAction() {
        dismiss(animated: true)
    }

    @objc func toggleBarsHidden() {
        if couldHideNavigation {
            setBarsHidden(!isBarsHidden)
        }
    }
}

private extension MangaReaderViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, MvvmCellViewModelWrapper<MvvmViewModel>>

    var isBarsHidden: Bool { navigationBarHiddenConstraint.isActive }

    func setBarsHidden(_ isHidden: Bool) {
        guard isBarsHidden != isHidden else { return }
        UIView.animate(withDuration: 0.3) { [self] in
            navigationBarHiddenConstraint.isActive = isHidden
            toolBarHiddenConstraint.isActive = isHidden || !viewModel.isActionsAvailable.value
            view.layoutIfNeeded()
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    func applyBookmarksMenu(_ bookmarks: [ApiMangaBookmarkModel], _ current: ApiMangaBookmarkModel?) {
        let actions: [UIAction] = bookmarks.map { bookmark in
                .init(title: bookmark.name, state: bookmark == current ? .on : .off) { [unowned self] _ in
                    viewModel.selectBookmark(bookmark)
                }
        }
        bookmarkButton.menu = UIMenu(children: actions)
    }

    func bindToCurrent(_ current: MangaDetailsChapterViewModel?) {
        guard let current else { return }
        bind(in: currentDisposeBag) {
            Observable.combineLatest(current.isLiked, current.likes).bind { [unowned self] isLiked, likes in
                let like = isLiked == true
                likeButton.configuration = like ? likeButton.configuration?.toFilled() : likeButton.configuration?.toTinted()
                likeButton.configuration?.image = like ? .init(systemName: "heart.fill") : .init(systemName: "heart")
                likeButton.configuration?.title = " \(likes)"
            }
        }
    }

    func applyModels(_ models: [MvvmViewModel]) {
        var snapshot = DataSource.Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(models.map { .init(viewModel: $0) }, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func applyMenu() {
        let test: [UIAction] = viewModel.chapters.value.enumerated().map { chapter in
            let readed = chapter.element.isReaded.value ? "" : " •"
            return UIAction(title: "Том \(chapter.element.tome.value) \(chapter.element.chapter.value)" + readed, state: chapter.offset == viewModel.currentChapter.value ? .on : .off) { [weak self] _ in
                self?.viewModel.currentChapter.accept(chapter.offset)
            }
        }
        headerTitleButton.menu = UIMenu(options: [.singleSelection], children: test)
    }

    func setupCollectionView() {
//        var section = UICollectionLayoutListConfiguration(appearance: .plain)
//        section.showsSeparators = false
//        let layout = UICollectionViewCompositionalLayout.list(using: section)
//        collectionView.collectionViewLayout = layout

        collectionView.dataSource = dataSource
        collectionView.delegate = delegates
    }

    var couldHideNavigation: Bool {
        let offset = collectionView.contentOffset.y
        let max = collectionView.contentSize.height - collectionView.frame.height
//        print(max - offset)
        return offset > 0 && max - offset > 0
    }

    func setNavigationVisibility(_ scrollView: UIScrollView) {
        let velocity = scrollView.panGestureRecognizer.velocity(in: view).y
        let couldHide = couldHideNavigation
        if !couldHide || velocity > 500 {
            setBarsHidden(false)
        } else if velocity < -500, couldHide {
            setBarsHidden(true)
        }
    }

    class Delegates: DelegateObject<MangaReaderViewController>, UINavigationBarDelegate, UIToolbarDelegate, UICollectionViewDelegateFlowLayout {
        func position(for bar: UIBarPositioning) -> UIBarPosition {
            if bar === parent.navigationBar {
                return .topAttached
            }
            if bar === parent.toolBar {
                return .bottom
            }
            fatalError("Unknown object appears")
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.setNavigationVisibility(scrollView)
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if let item = parent.viewModel.pages.value[indexPath.row] as? MangaReaderPageViewModel {
                let width = parent.traitCollection.horizontalSizeClass == .regular ? collectionView.readableContentGuide.layoutFrame.width : collectionView.safeAreaLayoutGuide.layoutFrame.width
                let height = (width / item.imageSize.value.width * item.imageSize.value.height).rounded(.toNearestOrEven)
                return .init(width: collectionView.frame.width, height: height)
            }

            if parent.viewModel.pages.value[indexPath.row] is MangaReaderLoadNextViewModel {
                return .init(width: collectionView.frame.width, height: 50)
            }

            return .zero
        }
    }
}
