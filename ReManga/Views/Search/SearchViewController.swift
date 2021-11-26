//
//  SearchViewController.swift
//  REManga
//
//  Created by Даниил Виноградов on 10.03.2021.
//

import Bond
import UIKit

class SearchViewController: BaseViewController<SearchViewModel> {
    enum Section {
        case main
    }

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var backgroundView: UIVisualEffectView!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var sideConstraints: [NSLayoutConstraint]!

    override var modalPresentationStyle: UIModalPresentationStyle {
        get { .overFullScreen }
        set {}
    }

    var collectionViewDataSource: UICollectionViewDiffableDataSource<Section, ReSearchContent>!

    var columns: CGFloat {
        view.traitCollection.horizontalSizeClass == .compact ? 3 : 5
    }

    var horizontalOffset: CGFloat {
        view.frame.width * 0.05
    }

    var verticalOffset: CGFloat {
        view.frame.height * 0.1
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateConstraints()
    }

    override func setupView() {
        super.setupView()

        transitioningDelegate = self
        searchBar.backgroundImage = UIImage()

        collectionViewDataSource = UICollectionViewDiffableDataSource<Section, ReSearchContent>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, content) -> UICollectionViewCell? in
            let cell = collectionView.dequeue(for: indexPath) as CatalogCellView
            cell.setModel(content)
            return cell
        })

        collectionView.backgroundColor = collectionView.backgroundColor?.withAlphaComponent(0.8)
        collectionView.register(cell: CatalogCellView.self)
        collectionView.dataSource = collectionViewDataSource
        collectionView.delegate = self

        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapDismiss)))
    }

    override func binding() {
        super.binding()

        bindingContext {
            viewModel.content.observeNext { [unowned self] content in
                var snapshot = NSDiffableDataSourceSnapshot<Section, ReSearchContent>()
                snapshot.appendSections([.main])
                snapshot.appendItems(content.collection)
                collectionViewDataSource.apply(snapshot)
            }

            viewModel.query.bidirectionalBind(to: searchBar.reactive.text)

            KeyboardHelper.shared.isHidden.observeNext { [unowned self] hidden in
                bottomConstraint?.constant = hidden ? self.verticalOffset : KeyboardHelper.shared.visibleHeight.value + self.horizontalOffset

                UIView.animate(withDuration: KeyboardHelper.shared.animationDuration.value) {
                    view.layoutIfNeeded()
                }
            }

            KeyboardHelper.shared.visibleHeight.observeNext { [unowned self] height in
                bottomConstraint?.constant = KeyboardHelper.shared.isHidden.value ? self.verticalOffset : height + self.horizontalOffset
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionViewDataSource.apply(collectionViewDataSource.snapshot())
    }

    @objc func tapDismiss() {
        viewModel.dismissWithCallback()
    }

    private func updateConstraints() {
        topConstraint.constant = verticalOffset
        sideConstraints.forEach { $0.constant = horizontalOffset }
        bottomConstraint.constant = KeyboardHelper.shared.isHidden.value ? verticalOffset : KeyboardHelper.shared.visibleHeight.value + horizontalOffset
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.itemSelected(indexPath.item)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frameWithoutInset: CGFloat = (collectionView.frame.width - 24)
        let frameSeparators = CGFloat(10 * (columns - 1))
        let itemWidth = CGFloat((frameWithoutInset - frameSeparators) / columns)

        return CGSize(width: itemWidth, height: itemWidth / 0.56)
    }
}

extension SearchViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeControllerPresentation(duration: 0.3, type: .present)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeControllerPresentation(duration: 0.3, type: .dismiss)
    }
}
