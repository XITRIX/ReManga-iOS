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
    }

    override func setupView() {
        super.setupView()
        navigationItem.largeTitleDisplayMode = .never

        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithTransparentBackground()
        navAppearance.backgroundColor = .secondarySystemBackground
        navigationItem.standardAppearance = navAppearance

        tableView.register(cell: TitleMetricsCell.self)
        tableView.register(cell: TitleDescriptionCell.self)
        tableView.register(cell: TitleTagsCell.self)
        tableView.register(cell: TitleTranslatersCell.self)
        tableView.register(cell: TitleSimilarCell.self)
        tableView.register(cell: TitleChapterCell.self)
        tableView.register(cell: TitleCommentCell.self)

        headerView.frame.size.height = view.frame.height * 4 / 5
        tableView.tableHeaderView = headerView
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
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

    override func binding() {
        super.binding()
        viewModel.rusName.observeNext { [unowned self] in
            titleView.text = $0
            titleView.sizeToFit()
        }.dispose(in: bag)

        viewModel.sectionSelected.bidirectionalMap(to: { item in
            item.rawValue
        }, from: { value in
            TitleViewModel.SectionItem(rawValue: value) ?? .about
        }).bidirectionalBind(to: sectionSelectorView.segment.reactive.selectedSegmentIndex).dispose(in: bag)

        viewModel.sectionSelected.observeNext { [unowned self] _ in
            UIView.performWithoutAnimation {
                tableView.reloadSections([0], with: .none)
                scrollViewDidScroll(tableView)
            }
        }.dispose(in: bag)

        viewModel.image.observeNext { [unowned self] link in
            headerView.imageView.kf.setImage(with: link)
        }.dispose(in: bag)
        viewModel.enName.bind(to: headerView.engTitleLabel).dispose(in: bag)
        viewModel.rusName.bind(to: headerView.ruTitleLabel).dispose(in: bag)
        viewModel.rating.bind(to: headerView.ratingLabel).dispose(in: bag)
        viewModel.info.bind(to: headerView.descriptionLabel).dispose(in: bag)

        viewModel.readingStatus.bind(to: headerView.readingStatusLabel).dispose(in: bag)

        viewModel.readingStatusDetails.observeNext { [unowned self] text in
            headerView.readingStatusDetailsLabel.isHidden = text == nil
            headerView.readingStatusDetailsLabel.text = text
        }.dispose(in: bag)

        viewModel.bookmark.bind(to: headerView.bookmarkStatusLabel).dispose(in: bag)

        viewModel.loaded.observeNext { [unowned self] _ in
            tableView.reloadData()
        }.dispose(in: bag)

        viewModel.chapters.observeNext { [unowned self] chapters in
            if viewModel.sectionSelected.value == .chapters {
                tableView.reloadSections([0], with: .automatic)
            }
        }.dispose(in: bag)

        viewModel.comments.observeNext { [unowned self] chapters in
            if viewModel.sectionSelected.value == .comments {
                tableView.reloadSections([0], with: .automatic)
            }
        }.dispose(in: bag)

        tableView.reactive.selectedRowIndexPath.observeNext { [unowned self] indexPath in
            if viewModel.sectionSelected.value == .chapters {
                viewModel.navigateChapter(viewModel.chapters.collection[indexPath.row].id)
            }
        }.dispose(in: bag)

        headerView.readingStatusButton.reactive.controlEvents(.touchUpInside).observeNext(with: viewModel.navigateCurrentChapter).dispose(in: bag)

        backButton.reactive.tap.observeNext(with: viewModel.dismiss).dispose(in: bag)
    }

    override var additionalSafeAreaInsets: UIEdgeInsets {
        get {
            var area = super.additionalSafeAreaInsets
            area.top = 0
            return area
        }
        set {
            super.additionalSafeAreaInsets = newValue
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
}

extension TitleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.sectionSelected.value {
        case .about:
            return Item.allCases.count
        case .chapters:
            return viewModel.chapters.count
        case .comments:
            return viewModel.comments.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

    func configureAboutCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        switch Item(rawValue: indexPath.row) {
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
                    let model = CatalogModel(title: tag.name, filter: CatalogFiltersModel(ordering: .rating, categories: [.init(id: tag.id, name: tag.name)]))
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
        default:
            return UITableViewCell()
        }
    }
}

extension TitleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        sectionSelectorView
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerView.imageTopConstraint.constant = scrollView.contentOffset.y
        print(tableView.safeAreaInsets.top)
        navigationBarIsHidden = scrollView.contentOffset.y < 200
    }
}
