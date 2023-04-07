//
//  MangaDetailsTagsCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 14.04.2023.
//

import UIKit
import MvvmFoundation
import RxCocoa

class MangaDetailsTagsCell<VM: MangaDetailsTagsViewModel>: MvvmCollectionViewCell<VM> {
    @IBOutlet private var tagListView: TagListView!

    override func initSetup() {
        tagListView.marginX = 8
        tagListView.marginY = 8
        tagListView.paddingX = 16
        tagListView.paddingY = 8
        
        tagListView.textFont = .systemFont(ofSize: 15)
//        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(999), heightDimension: .estimated(28))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(999), heightDimension: .estimated(28))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//        let section = NSCollectionLayoutSection(group: group)
//        section.interGroupSpacing = 8
////        section.orthogonalScrollingBehavior = .continuous
//        section.contentInsetsReference = .layoutMargins
//        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
    }

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
//            viewModel.tags.bind(to: collectionView.rx.items) { collectionView, item, model in
//                model.resolveCell(from: collectionView, at: IndexPath(item: item, section: 0))
//            }
            viewModel.tags.bind { [unowned self] tags in
                tagListView.removeAllTags()
                tagListView.addTags(tags.compactMap { $0.title.value }).forEach { tagView in
                    tagView.cornerRadius = tagView.frame.height / 2
                    tagView.layer.cornerCurve = .continuous
                }
            }
        }
    }

}
