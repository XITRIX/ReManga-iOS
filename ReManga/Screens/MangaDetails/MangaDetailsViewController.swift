//
//  MangaDetailsViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 13.04.2023.
//

import UIKit
import MvvmFoundation

class MangaDetailsViewController<VM: MangaDetailsViewModel>: BaseViewController<VM> {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var headerCapView: UIView!

    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var imageViewHolder: UIView!
    @IBOutlet private var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var collectionView: UICollectionView!

    private var dataSource: DataSource!
    private lazy var delegates = Delegates(parent: self)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCap()
        setupNavigationAppearance()
        setupCollectionView()

        bind(in: disposeBag) {
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

    let categoryCellregistration: UICollectionView.CellRegistration<UICollectionViewListCell, String> = {
      // 2
        return .init { cell, _, item in
          // 3
          var configuration = cell.defaultContentConfiguration()
          configuration.text = item
          cell.contentConfiguration = configuration
      }
    }()
}

private extension MangaDetailsViewController {
    func applyModels(_ sections: [MvvmCollectionSectionModel]) {
        var snapshot = DataSource.Snapshot()
        snapshot.appendSections(sections)
        for section in sections {
            snapshot.appendItems(section.items.map { .init(viewModel: $0) }, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: false) {
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

        let scrollButtonsAppearance = UIBarButtonItemAppearance()
        scrollButtonsAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]

        let scrollAppearance = UINavigationBarAppearance()
        scrollAppearance.configureWithTransparentBackground()
        scrollAppearance.buttonAppearance = scrollButtonsAppearance
        scrollAppearance.setBackIndicatorImage(.init(systemName: "chevron.backward.circle.fill")?.withTintColor(.label, renderingMode: .alwaysOriginal), transitionMaskImage: .init(systemName: "chevron.backward.circle.fill"))
        navigationItem.scrollEdgeAppearance = scrollAppearance

        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        navigationItem.standardAppearance = appearance

        navigationItem.largeTitleDisplayMode = .never
    }

    func setupCollectionView() {
        collectionView.backgroundView = imageViewHolder
        collectionView.delegate = delegates

        collectionView.register(type: DetailsTitleHeaderCell.self)
        collectionView.register(type: DetailsHeaderCap.self)

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

