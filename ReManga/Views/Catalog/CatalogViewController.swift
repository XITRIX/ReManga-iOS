//
//  CatalogViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 04.11.2021.
//

import Bond
import UIKit

class CatalogViewController: BaseViewController<CatalogViewModel> {
    @IBOutlet var collectionView: UICollectionView!

    var filterButton: UIBarButtonItem?
    var filterIcon: UIImage? {
        viewModel.isFiltersSelected ? UIImage(systemName: "line.3.horizontal.decrease.circle.fill") : UIImage(systemName: "line.horizontal.3.decrease.circle")
    }

    var columns: CGFloat {
        view.traitCollection.horizontalSizeClass == .compact ? 3 : 5
    }

    override func setupView() {
        super.setupView()

        var items = [UIBarButtonItem]()
        if viewModel.allowFiltering {
            let button = UIBarButtonItem(image: filterIcon, style: .plain, target: self, action: #selector(filter))
            filterButton = button
            items.append(button)
        }
        if viewModel.allowSearching {
            items.append(UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search)))
        }
        navigationItem.setRightBarButtonItems(items, animated: false)

        navigationItem.largeTitleDisplayMode = .always
        collectionView.register(cell: CatalogCellView.self)
        collectionView.delegate = self
    }

    override func binding() {
        super.binding()

        viewModel.state.observeNext { [unowned self] _ in
            filterButton?.image = filterIcon
        }.dispose(in: bag)

        viewModel.collection.bind(to: collectionView) { content, indexPath, collectionView in
            let cell = collectionView.dequeue(for: indexPath) as CatalogCellView
            cell.setModel(content[indexPath.item])
            return cell
        }
    }

    @objc func search() {
        viewModel.navigateSearch()
    }

    @objc func filter() {
        viewModel.navigateFilter()
    }
}

extension CatalogViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.height > scrollView.contentSize.height - 200 {
            viewModel.loadNext()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.titleSelected(at: indexPath.item)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frameWithoutInset: CGFloat = (collectionView.frame.width - 24 - collectionView.safeAreaInsets.left - collectionView.safeAreaInsets.right)
        let frameSeparators = CGFloat(10 * (columns - 1))
        let itemWidth = CGFloat((frameWithoutInset - frameSeparators) / columns)

        return CGSize(width: itemWidth, height: itemWidth / 0.56)
    }
}
