//
//  TestViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 19.04.2023.
//

import MvvmFoundation
import RxSwift
import UIKit

class TestViewController<VM: MangaReaderViewModel>: BaseViewController<VM> {
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var navigationBar: UINavigationBar!
    @IBOutlet private var toolBar: UIToolbar!
    @IBOutlet private var navHeaderView: UIView!
    @IBOutlet private var likeButton: UIButton!

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

    override func viewDidLoad() {
        super.viewDidLoad()

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
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        collectionView.contentInset.top = navigationBar.frame.height
        collectionView.contentInset.bottom = toolBar.frame.height

        collectionView.verticalScrollIndicatorInsets.top = collectionView.contentInset.top
        collectionView.verticalScrollIndicatorInsets.bottom = collectionView.contentInset.bottom
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

private extension TestViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, MvvmCellViewModelWrapper<MvvmViewModel>>

    var isBarsHidden: Bool { navigationBarHiddenConstraint.isActive && toolBarHiddenConstraint.isActive }

    func setBarsHidden(_ isHidden: Bool) {
        guard isBarsHidden != isHidden else { return }
        UIView.animate(withDuration: 0.3) { [self] in
            navigationBarHiddenConstraint.isActive = isHidden
            toolBarHiddenConstraint.isActive = isHidden
            view.layoutIfNeeded()
            setNeedsStatusBarAppearanceUpdate()
        }
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

    class Delegates: DelegateObject<TestViewController>, UINavigationBarDelegate, UIToolbarDelegate, UICollectionViewDelegateFlowLayout {
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
