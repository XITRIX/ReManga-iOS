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
    private var viewModel: VM!
    private lazy var delegates = Delegates(parent: self)

    override func initSetup() {
        tagListView.marginX = 8
        tagListView.marginY = 8
        tagListView.paddingX = 16
        tagListView.paddingY = 8

        tagListView.delegate = delegates
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
        self.viewModel = viewModel
        bind(in: disposeBag) {
            viewModel.tags.bind { [unowned self] tags in
                tagListView.removeAllTags()
                tagListView.addTags(tags.map { $0.tag.value?.name ?? "" }).forEach { tagView in
                    tagView.cornerRadius = tagView.frame.height / 2
                    tagView.layer.cornerCurve = .continuous
                }
            }
        }
    }
}

private extension MangaDetailsTagsCell {
    class Delegates: DelegateObject<MangaDetailsTagsCell>, TagListViewDelegate {
        func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
            for tag in sender.tagViews.enumerated() {
                if tag.element == tagView {
                    guard let tag = parent.viewModel.tags.value[tag.offset].tag.value
                    else { return }

                    parent.viewModel.tagSelected.accept(tag)
                }
            }
        }
    }
}
