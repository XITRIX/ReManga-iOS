//
//  CatalogViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 04.11.2021.
//

import UIKit
import Bond

class CatalogViewController: BaseViewController<CatalogViewModel> {
    @IBOutlet var collectionView: UICollectionView!

    var columns: CGFloat {
        view.traitCollection.horizontalSizeClass == .compact ? 3 : 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if viewModel.allowSearching {
            let search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
            navigationItem.setRightBarButtonItems([search], animated: false)
        }

        navigationItem.largeTitleDisplayMode = .always
        collectionView.register(cell: CatalogCellView.self)
        collectionView.delegate = self

        viewModel.collection.bind(to: collectionView) { content, indexPath, collectionView in
            let cell = collectionView.dequeue(for: indexPath) as CatalogCellView
            cell.setModel(content[indexPath.item])
            return cell
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Large title dirty fix
        navigationController?.view.setNeedsLayout()
        navigationController?.view.layoutIfNeeded()
    }

    @objc func search() {
        viewModel.navigateSearch()
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
        let frameWithoutInset: CGFloat = (collectionView.frame.width - 24)
        let frameSeparators = CGFloat(10 * (columns - 1))
        let itemWidth = CGFloat((frameWithoutInset - frameSeparators) / columns)

        return CGSize(width: itemWidth, height: itemWidth / 0.56)
    }
}
