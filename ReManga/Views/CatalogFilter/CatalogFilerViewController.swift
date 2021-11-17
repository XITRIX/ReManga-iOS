//
//  CatalogFilerViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 06.11.2021.
//

import TTGTags
import UIKit

class CatalogFilerViewController: BaseViewController<CatalogFilterViewModel> {
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var tableView: UITableView!

    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var doneButton: UIBarButtonItem!

    @IBOutlet var verticalConstraints: [NSLayoutConstraint]!
    @IBOutlet var horizontalConstraints: [NSLayoutConstraint]!

    @IBOutlet var holderView: UIView!
    override var modalPresentationStyle: UIModalPresentationStyle {
        get { .overFullScreen }
        set {}
    }

    var horizontalOffset: CGFloat {
        view.frame.width * 0.05
    }

    var verticalOffset: CGFloat {
        view.frame.height * 0.1
    }

    var sectionHidden = [Bool].init(repeating: true, count: SectionItem.allCases.count)

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateConstraints()
    }

    override func setupView() {
        super.setupView()
        transitioningDelegate = self

        tableView.register(cell: CatalogFilterCell.self)
        tableView.contentInset.top = navigationBar.frame.size.height
        tableView.contentInset.bottom = 44
        tableView.verticalScrollIndicatorInsets.top = navigationBar.frame.size.height
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.backgroundColor = tableView.backgroundColor?.withAlphaComponent(0.8)
    }

    override func binding() {
        super.binding()
        viewModel.state.observeNext { [unowned self] _ in
            tableView.reloadData()
        }.dispose(in: bag)

        cancelButton.reactive.tap.observeNext(with: viewModel.dismiss).dispose(in: bag)
        doneButton.reactive.tap.observeNext(with: viewModel.done).dispose(in: bag)
    }

    override func updateOverlay(_ old: UIViewController?) {
        if overlay == old { return }

        old?.remove()
        overlay?.insert(to: self, at: 1, in: holderView)
    }

    private func updateConstraints() {
        verticalConstraints.forEach { $0.constant = verticalOffset }
        horizontalConstraints.forEach { $0.constant = horizontalOffset }
    }
}

extension CatalogFilerViewController {
    enum SectionItem: String, CaseIterable {
        case genres = "Жанры"
        case categories = "Категории"
        case types = "Типы"
        case status = "Статус"
        case ageLimit = "Ограничения"
    }
}

extension CatalogFilerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.state.value == .done ? SectionItem.allCases.count : 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionItem = SectionItem.allCases[indexPath.section]
        let cell = tableView.dequeue(for: indexPath) as CatalogFilterCell
        cell.titleLabel.text = SectionItem.allCases[indexPath.section].rawValue
        let items = getFilterCatalog(for: SectionItem.allCases[indexPath.section])
        cell.tagsView.removeAllTags()
        cell.tagsView.add(items.map { item in
            let style = TTGTextTagStyle()
            style.cornerRadius = 10
            style.shadowRadius = 0
            style.shadowOffset = .zero
            style.borderWidth = 0
            style.backgroundColor = .tertiarySystemBackground
            style.extraSpace = CGSize(width: 24, height: 12)

            let content = TTGTextTagStringContent(text: item.name)
            content.textColor = .label
            content.textFont = .systemFont(ofSize: 14)

            let selectedStyle = style.copy() as! TTGTextTagStyle
            selectedStyle.backgroundColor = view.tintColor

            let tag = TTGTextTag(content: content, style: style, selectedContent: content, selectedStyle: selectedStyle)
            tag.selected = getFilterSelected(for: sectionItem).contains(where: { $0.id == item.id })
            return tag
        })
        cell.configure(sectionHidden[indexPath.section], animated: false)
        cell.clicked = { [weak self] hidden in
            guard let self = self else { return }
            self.sectionHidden[indexPath.section] = hidden

            tableView.beginUpdates()
            cell.configure(hidden, animated: true)
            tableView.endUpdates()
        }
        cell.tagSelected = { [weak self] index, selected in
            guard let self = self else { return }

            self.setFilterSelected(for: sectionItem, index: index, selected: selected)
            let filtersCount = self.getFilterSelected(for: sectionItem).count
            cell.filtersCountLabel.text = "\(filtersCount)"
            cell.filtersCountHolder.isHidden = filtersCount == 0
        }
        
        let filtersCount = self.getFilterSelected(for: sectionItem).count
        cell.filtersCountLabel.text = "\(filtersCount)"
        cell.filtersCountHolder.isHidden = filtersCount == 0

        return cell
    }

    func getFilterCatalog(for item: SectionItem) -> [ReCatalogFilterItem] {
        switch item {
        case .genres:
            return viewModel.availableFilters.value?.genres ?? []
        case .categories:
            return viewModel.availableFilters.value?.categories ?? []
        case .types:
            return viewModel.availableFilters.value?.types ?? []
        case .status:
            return viewModel.availableFilters.value?.status ?? []
        case .ageLimit:
            return viewModel.availableFilters.value?.ageLimit ?? []
        }
    }

    func getFilterSelected(for item: SectionItem) -> [ReCatalogFilterItem] {
        switch item {
        case .genres:
            return viewModel.filters.genres
        case .categories:
            return viewModel.filters.categories
        case .types:
            return viewModel.filters.types
        case .status:
            return viewModel.filters.status
        case .ageLimit:
            return viewModel.filters.ageLimit
        }
    }

    func setFilterSelected(for item: SectionItem, index: Int, selected: Bool) {
        let filter = getFilterCatalog(for: item)[index]
        switch item {
        case .genres:
            selected
                ? viewModel.filters.genres.append(filter)
                : viewModel.filters.genres.removeAll(where: { $0 == filter })
        case .categories:
            selected
                ? viewModel.filters.categories.append(filter)
                : viewModel.filters.categories.removeAll(where: { $0 == filter })
        case .types:
            selected
                ? viewModel.filters.types.append(filter)
                : viewModel.filters.types.removeAll(where: { $0 == filter })
        case .status:
            selected
                ? viewModel.filters.status.append(filter)
                : viewModel.filters.status.removeAll(where: { $0 == filter })
        case .ageLimit:
            selected
                ? viewModel.filters.ageLimit.append(filter)
                : viewModel.filters.ageLimit.removeAll(where: { $0 == filter })
        }
    }
}

extension CatalogFilerViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeControllerPresentation(duration: 0.3, type: .present)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeControllerPresentation(duration: 0.3, type: .dismiss)
    }
}
