//
//  TitleViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 04.11.2021.
//

import Kingfisher
import MarqueeLabel
import TTGTags
import UIKit

class TitleViewController: BaseViewController<TitleViewModel> {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: TitleHeaderView!
    @IBOutlet var sectionSelectorView: TitleSectionSelectorView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var backButtonConstraint: NSLayoutConstraint!
    var titleView: MarqueeLabel!
    var dataSource: UITableViewDiffableDataSource<Int, Int>?

    override var hidesTopBar: Bool {
        get { true }
        set {}
    }

//    override var hidesBottomBar: Bool {
//        get { true }
//        set {}
//    }

    override var navigationBarIsHidden: Bool? {
        didSet {
            UIView.animate(withDuration: 0.3) { [unowned self] in
                backButton.alpha = (navigationBarIsHidden ?? true) ? 1 : 0
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        smoothlyDeselectRows(in: tableView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backButtonConstraint.constant = (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) + 6
        backButton.isHidden = navigationController?.viewControllers.count ?? 0 <= 1
        headerView.frame.size.height = view.safeFrame.height * 4 / 5
    }

    override func setupView() {
        super.setupView()
        navigationItem.largeTitleDisplayMode = .never

//        dataSource = UITableViewDiffableDataSource<Int, Int>(tableView: tableView, cellProvider: { [unowned self] tableView, indexPath, itemIdentifier in
//            switch viewModel.sectionSelected.value {
//            case .about:
//                return configureAboutCell(tableView, at: indexPath)
//            case .chapters:
//                return configureChaptersCell(tableView, at: indexPath)
//            case .comments:
//                return configureCommentsCell(tableView, at: indexPath)
//            }
//        })

        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithTransparentBackground()
        navAppearance.backgroundColor = .secondarySystemBackground
        navAppearance.backgroundEffect = UIBlurEffect(style: .systemThickMaterial)
        navigationItem.standardAppearance = navAppearance

        tableView.register(cell: TitleMetricsCell.self)
        tableView.register(cell: TitleDescriptionCell.self)
        tableView.register(cell: TitleTagsCell.self)
        tableView.register(cell: TitleTranslatersCell.self)
        tableView.register(cell: TitleSimilarCell.self)
        tableView.register(cell: TitleChapterCell.self)
        tableView.register(cell: TitleCommentCell.self)
        tableView.register(cell: TitleLoadingCell.self)

        tableView.tableHeaderView = headerView
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
//        tableView.dataSource = dataSource
        tableView.dataSource = self
        tableView.delegate = self
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }

        titleView = MarqueeLabel(frame: .zero, rate: 80, fadeLength: 10)
        titleView.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleView.trailingBuffer = 44
        navigationItem.titleView = titleView
    }

    override func updateOverlay(_ old: UIViewController?) {
        if overlay == old { return }

        old?.remove()
        overlay?.insert(to: self, at: 1, in: view)
    }

    func reloadTableView() {
        tableView.reloadSections([0], with: .none)
//        var snap = NSDiffableDataSourceSnapshot<Int, Int>()
//        snap.appendSections([0])
//
//        switch viewModel.sectionSelected.value {
//        case .about:
//            snap.appendItems(allVisibleItems.map { $0.rawValue }, toSection: 0)
//        case .chapters:
////            return viewModel.chapters.count
//            snap.appendItems(viewModel.chapters.array.map { $0.id }, toSection: 0)
//        case .comments:
//            //            return viewModel.comments.count
//            snap.appendItems(viewModel.comments.array.map { $0.id }, toSection: 0)
//        }
//
//        dataSource?.apply(snap, animatingDifferences: true)
    }

    deinit {
        print("Deinit!!!!!!!")
    }

    override func binding() {
        super.binding()

        bind(in: bag) {
            backButton.bindTap(viewModel.dismiss)

            viewModel.enName.bind(to: headerView.engTitleLabel)
            viewModel.rusName.bind(to: headerView.ruTitleLabel)
            viewModel.rating.bind(to: headerView.ratingLabel)
            viewModel.info.bind(to: headerView.descriptionLabel)
            viewModel.readingStatus.bind(to: headerView.readingStatusLabel)
            viewModel.bookmark.bind(to: headerView.bookmarkStatusLabel)
            viewModel.image.bind(to: headerView.imageView.reactive.imageUrl)
            headerView.readingStatusButton.bindTap(viewModel.navigateCurrentChapter)

            viewModel.rusName.observeNext { [unowned self] in
                titleView.text = $0
                titleView.sizeToFit()
            }

            viewModel.sectionSelected.bidirectionalMap(to: { item in
                item.rawValue
            }, from: { value in
                TitleViewModel.SectionItem(rawValue: value) ?? .about
            }).bidirectionalBind(to: sectionSelectorView.segment.reactive.selectedSegmentIndex)

            viewModel.sectionSelected.observeNext { [unowned self] _ in
                UIView.performWithoutAnimation {
                    reloadTableView()
                    scrollViewDidScroll(tableView)
                }
            }

            viewModel.readingStatusDetails.observeNext { [unowned self] text in
                headerView.readingStatusDetailsLabel.isHidden = text == nil
                headerView.readingStatusDetailsLabel.text = text
            }

            viewModel.loaded.observeNext { [unowned self] _ in
                reloadTableView()
            }

            viewModel.chapters.observeNext { [unowned self] _ in
                if viewModel.sectionSelected.value == .chapters {
                    reloadTableView()
                }
            }

            viewModel.comments.observeNext { [unowned self] _ in
                if viewModel.sectionSelected.value == .comments {
                    reloadTableView()
                }
            }

            tableView.reactive.selectedRowIndexPath.observeNext { [unowned self] indexPath in
                if viewModel.sectionSelected.value == .chapters,
                   !viewModel.chapters.isEmpty {
                    viewModel.navigateChapter(viewModel.chapters.collection[indexPath.row].id)
                }
            }
        }
    }
}

extension TitleViewController {
    enum Item: Int, CaseIterable {
        case metrics
        case description
        case tags
        case translaters
        case similar
    }

    var allVisibleItems: [Item] {
        var res: [Item] = [.metrics]
        if !(viewModel.description.value?.string.isEmpty ?? true) { res.append(.description) }
        if !viewModel.categories.isEmpty { res.append(.tags) }
        if !viewModel.publishers.isEmpty { res.append(.translaters) }
        res.append(.similar)
        return res
    }
}

extension TitleViewController: UITableViewDataSource {
    func getRowsCount(at section: Int) -> Int {
        switch viewModel.sectionSelected.value {
        case .about:
            return allVisibleItems.count
        case .chapters:
            return viewModel.chapters.count
        case .comments:
            return viewModel.comments.count
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(1, getRowsCount(at: section))
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard getRowsCount(at: indexPath.section) > 0
        else { return configureLoadingCell(tableView, at: indexPath) }

        switch viewModel.sectionSelected.value {
        case .about:
            return configureAboutCell(tableView, at: indexPath)
        case .chapters:
            return configureChaptersCell(tableView, at: indexPath)
        case .comments:
            return configureCommentsCell(tableView, at: indexPath)
        }
    }

    func configureChaptersCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(for: indexPath) as TitleChapterCell
        cell.setModel(viewModel.chapters.collection[indexPath.row])
        return cell
    }

    func configureCommentsCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(for: indexPath) as TitleCommentCell
        cell.setModel(viewModel.comments.collection[indexPath.row])
        return cell
    }

    func configureLoadingCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(for: indexPath) as TitleLoadingCell
//        cell.setModel(viewModel.comments.collection[indexPath.row])
        return cell
    }

    func configureAboutCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        switch allVisibleItems[indexPath.row] {
        case .metrics:
            let cell = tableView.dequeue(for: indexPath) as TitleMetricsCell
            viewModel.totalVotes.bind(to: cell.likesLabel).dispose(in: cell.bag)
            viewModel.totalViews.bind(to: cell.viewsLabel).dispose(in: cell.bag)
            viewModel.countBookmarks.bind(to: cell.bookmarksLabel).dispose(in: cell.bag)
            return cell
        case .description:
            let cell = tableView.dequeue(for: indexPath) as TitleDescriptionCell
            viewModel.description.bind(to: cell.descriptionLabel.reactive.attributedText).dispose(in: cell.bag)
            viewModel.descriptionShorten.observeNext { shorten in
                tableView.beginUpdates()
                cell.descriptionLabel.numberOfLines = shorten ? 5 : 0
                cell.showMoreButton.isHidden = !shorten
                tableView.endUpdates()
            }.dispose(in: cell.bag)
            cell.showMoreButton.reactive.tap.map { false }.bind(to: viewModel.descriptionShorten).dispose(in: cell.bag)
            return cell
        case .tags:
            let cell = tableView.dequeue(for: indexPath) as TitleTagsCell
            viewModel.categories.observeNext {
                cell.tagsView.add($0.collection.compactMap {
                    let style = TTGTextTagStyle()
                    style.cornerRadius = 10
                    style.shadowRadius = 0
                    style.shadowOffset = .zero
                    style.borderWidth = 0
                    style.backgroundColor = .tertiarySystemBackground
                    style.extraSpace = CGSize(width: 24, height: 12)

                    let content = TTGTextTagStringContent(text: $0.name)
                    content.textColor = .label
                    content.textFont = .systemFont(ofSize: 14)

                    return TTGTextTag(content: content, style: style)
                })
                cell.tagSelected = { [weak self] index in
                    guard let self = self else { return }

                    let tag = self.viewModel.categories.collection[index]
                    let model = CatalogModel(title: tag.name, filter: CatalogFiltersModel(categories: [.init(id: tag.id, name: tag.name)]))
                    self.viewModel.navigateCatalog(model)
                }
            }.dispose(in: cell.bag)
            return cell
        case .translaters:
            let cell = tableView.dequeue(for: indexPath) as TitleTranslatersCell
            viewModel.publishers.observeNext { models in
                cell.configure(with: models.collection)
            }.dispose(in: cell.bag)
            return cell
        case .similar:
            let cell = tableView.dequeue(for: indexPath) as TitleSimilarCell
            viewModel.similar.bind(to: cell.collectionView) { models, indexPath, collectionView in
                let cell = collectionView.dequeue(for: indexPath) as TitleSimilarCollectionCell
                cell.setModel(models[indexPath.item])
                return cell
            }.dispose(in: cell.bag)
            cell.collectionView.reactive.selectedItemIndexPath.observeNext { [unowned self] indexPath in
                if let dir = viewModel.similar.collection[indexPath.item].dir {
                    viewModel.navigateTitle(dir)
                }
            }.dispose(in: cell.bag)
            return cell
        }
    }
}

extension TitleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        sectionSelectorView
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerView.imageTopConstraint.constant = scrollView.contentOffset.y
//        print(tableView.safeAreaInsets.top)
        navigationBarIsHidden = scrollView.contentOffset.y < 200
//        updateFooter()
    }
}
