//
//  MangaDetailsTagsCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 14.04.2023.
//

import UIKit
import MvvmFoundation
import RxSwift
import RxCocoa

class MangaDetailsTagsCell<VM: MangaDetailsTagsViewModel>: MvvmCollectionViewCell<VM> {
    @IBOutlet private var tagListView: TagListView!
    private var viewModel: VM!
    private lazy var delegates = Delegates(parent: self)
    private let maxNonExpandedTags = 6
    private var cropped = false

    override func initSetup() {
        tagListView.marginX = 8
        tagListView.marginY = 8
        tagListView.paddingX = 16
        tagListView.paddingY = 8
        tagListView.tagBackgroundColor = .secondarySystemBackground

        tagListView.delegate = delegates
        tagListView.textFont = .systemFont(ofSize: 15)
    }

    override func setup(with viewModel: VM) {
        self.viewModel = viewModel
        bind(in: disposeBag) {
            Observable.combineLatest(viewModel.tags, viewModel.isExpanded).bind { [unowned self] (tags, expanded) in
                updateTags(tags, isExpanded: expanded)
            }
//            viewModel.tags.bind { [unowned self] tags in
//                updateTags(tags)
//            }
//            viewModel.isExpanded.bind { [unowned self] expanded in
//                updateTags(viewModel.tags.value)
//            }
        }
    }
}

private extension MangaDetailsTagsCell {
    class Delegates: DelegateObject<MangaDetailsTagsCell>, TagListViewDelegate {
        func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
            for tag in sender.tagViews.enumerated() {
                if tag.element == tagView {
                    if parent.cropped && tag.offset == parent.maxNonExpandedTags - 1 {
                        parent.viewModel.isExpanded.accept(true)
                        return
                    }

                    guard let tag = parent.viewModel.tags.value[tag.offset].tag.value
                    else { return }

                    parent.viewModel.tagSelected.accept(tag)
                }
            }
        }
    }

    func updateTags(_ tags: [MangaDetailsTagViewModel], isExpanded: Bool) {
        var _tags = tags
        cropped = false
        if !isExpanded && tags.count > maxNonExpandedTags {
            _tags = Array(_tags.prefix(upTo: maxNonExpandedTags - 1))
            cropped = true
        }

        tagListView.removeAllTags()
        tagListView.addTags(_tags.map { $0.tag.value?.name ?? "" }).forEach { tagView in
            tagView.cornerRadius = tagView.frame.height / 2
            tagView.layer.cornerCurve = .continuous
        }

        if cropped {
            let tagView = tagListView.addTag("+ ещё \(tags.count - maxNonExpandedTags + 1)")
            tagView.backgroundColor = .tintColor
            tagView.cornerRadius = tagView.frame.height / 2
            tagView.layer.cornerCurve = .continuous
        }

        invalidateIntrinsicContentSize()
    }
}
