//
//  MangaDetailsViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 13.04.2023.
//

import UIKit
import MvvmFoundation
import MarqueeLabel

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
    //    private let navTitleLabel = MarqueeLabel(frame: .init(x: 0, y: 0, width: 900, height: 44), rate: 24, fadeLength: 16)

    private var dataSource: DataSource!
    private lazy var delegates = Delegates(parent: self)

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.overrideUserInterfaceStyle = .dark
        subtitleLabel.overrideUserInterfaceStyle = .dark

        setupCap()
        setupNavigationAppearance()
        setupCollectionView()

        bind(in: disposeBag) {
            viewModel.title.bind { [unowned self] text in
                navTitleLabel.text = text
//                navTitleLabel.sizeToFit()
            }
            collectionView.rx.itemSelected.bind { [unowned self] indexPath in
                viewModel.itemSelected(at: indexPath)
            }
            viewModel.image.bind { [unowned self] img in
                activityIndicator.startAnimating()
                imageView.setImage(img) { [weak self] in
                    self?.activityIndicator.stopAnimating()
                }
            }
            viewModel.items.bind { [unowned self] models in
                applyModels(models)
            }
            titleLabel.rx.text <- viewModel.title
            subtitleLabel.rx.text <- viewModel.detail
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selected = collectionView.indexPathsForSelectedItems?.first {
            collectionView.deselectItem(at: selected, animated: true)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCollectionViewInset()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in } completion: { _ in
            self.collectionView.reloadData()
        }
    }
}

private extension MangaDetailsViewController {
    func applyModels(_ sections: [MvvmCollectionSectionModel]) {
        var snapshot = DataSource.Snapshot()
        snapshot.appendSections(sections)
        for section in sections {
            snapshot.appendItems(section.items.map { .init(viewModel: $0) }, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: true) {
            self.updateCollectionViewInset()
        }
    }

    func updateCollectionViewInset() {
        DispatchQueue.main.async { [self] in
            collectionView.contentInset.top = contentOffset
        }
    }

    func setupCap() {
        headerCapView.layer.cornerRadius = 16
        headerCapView.layer.cornerCurve = .continuous
        headerCapView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    func setupNavigationAppearance() {
        navigationController?.setOverrideTraitCollection(UITraitCollection(userInterfaceLevel: .elevated), forChild: self)

//        navTitleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
//        navTitleLabel.numberOfLines = 1
//        navTitleLabel.textAlignment = .center
        navigationItem.titleView = navTitleView

        let scrollButtonsAppearance = UIBarButtonItemAppearance()
        scrollButtonsAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]

        let scrollAppearance = UINavigationBarAppearance()
        scrollAppearance.configureWithTransparentBackground()
        scrollAppearance.buttonAppearance = scrollButtonsAppearance
        scrollAppearance.titleTextAttributes = [.foregroundColor: UIColor.clear]
        scrollAppearance.setBackIndicatorImage(.init(systemName: "chevron.backward.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal), transitionMaskImage: .init(systemName: "chevron.backward.circle.fill"))
        navigationItem.scrollEdgeAppearance = scrollAppearance

        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        navigationItem.standardAppearance = appearance

        navigationItem.largeTitleDisplayMode = .never
    }

    func setupCollectionView() {
        collectionView.backgroundView = imageViewHolder
        collectionView.delegate = delegates

        collectionView.collectionViewLayout =
        UICollectionViewCompositionalLayout(sectionProvider: { [unowned self] section, env in
            let sectionModel = viewModel.items.value[section]

            var configuration = UICollectionLayoutListConfiguration(appearance: sectionModel.style.sectionStyle)
            if let backgroundColor = sectionModel.backgroundColor {
                configuration.backgroundColor = backgroundColor
            }
            configuration.showsSeparators = sectionModel.showsSeparators

            let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: env)
            return section
        })

        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            item.viewModel.resolveCell(from: collectionView, at: indexPath)
        }

        collectionView.dataSource = dataSource
    }

    var contentOffset: Double {
        min(collectionView.bounds.width * 1.41, collectionView.layoutMarginsGuide.layoutFrame.height * 3.0 / 4.0)
    }
}

private extension MangaDetailsViewController {
    class Delegates: DelegateObject<MangaDetailsViewController>, UICollectionViewDelegate {
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.imageViewHeightConstraint.constant = -scrollView.contentOffset.y

            let offset = scrollView.contentOffset.y + scrollView.contentInset.top
            let alpha = max(0, min(offset / 8, 1))
            parent.navTitleLabel.isHidden = alpha <= 0
            parent.navTitleLabel.alpha = alpha

            if scrollView.contentOffset.y + scrollView.bounds.height > scrollView.contentSize.height - 400 {
                parent.viewModel.bottomReached()
            }
        }
    }

    class DataSource: UICollectionViewDiffableDataSource<MvvmCollectionSectionModel, MvvmCellViewModelWrapper<MvvmViewModel>> {
//        typealias Snapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>
    }
}

extension MvvmCollectionSectionModel.Style {
    var sectionStyle: UICollectionLayoutListConfiguration.Appearance {
        switch self {
        case .plain:
            return .plain
        case .grouped:
            return .grouped
        case .insetGrouped:
            return .insetGrouped
        }
    }
}

