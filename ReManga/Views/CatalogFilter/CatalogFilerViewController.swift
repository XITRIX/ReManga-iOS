//
//  CatalogFilerViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 06.11.2021.
//

import UIKit

class CatalogFilerViewController: BaseViewController<CatalogFilterViewModel> {
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var tableView: UITableView!

    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var doneButton: UIBarButtonItem!

    @IBOutlet var verticalConstraints: [NSLayoutConstraint]!
    @IBOutlet var horizontalConstraints: [NSLayoutConstraint]!

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

    override func viewDidLoad() {
        super.viewDidLoad()

        transitioningDelegate = self
        tableView.contentInset.top = navigationBar.frame.size.height

        binding()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateConstraints()
    }

    func binding() {
        viewModel.availableFilters.observeNext { [unowned self] filters in
            tableView.reloadData()
        }.dispose(in: bag)

        cancelButton.reactive.tap.observeNext(with: viewModel.dismiss).dispose(in: bag)
        doneButton.reactive.tap.observeNext(with: viewModel.dismiss).dispose(in: bag)
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
        SectionItem.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}

extension CatalogFilerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        SectionItem.allCases[section].rawValue
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
