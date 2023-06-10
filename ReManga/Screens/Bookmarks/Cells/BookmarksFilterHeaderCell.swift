//
//  BookmarksFilterHeaderCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 06.06.2023.
//

import UIKit
import MvvmFoundation

class BookmarksFilterSegmentedControl: UISegmentedControl {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

class BookmarksFilterHeaderCell<VM: BookmarksFilterHeaderViewModel>: MvvmCollectionViewListCell<VM> {
    @IBOutlet private var segmentView: UISegmentedControl!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var blurView: UIVisualEffectView!

    override var attachCellToContentView: Bool { false }

    override func initSetup() {
        let width = segmentView.widthAnchor.constraint(equalTo: layoutMarginsGuide.widthAnchor)
        width.priority = .defaultLow
        width.isActive = true
    }

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            blurView.rx.alpha <- viewModel.blurAlpha
            viewModel.filtersList.bind { [unowned self] filters in
                segmentView.removeAllSegments()
                segmentView.insertSegment(withTitle: "Все", at: 0, animated: false)
                for filter in filters.enumerated() {
                    segmentView.insertSegment(withTitle: filter.element.name, at: filter.offset + 1, animated: false)
                }
                segmentView.selectedSegmentIndex = getIndex(of: viewModel.selectedFilter.value)
            }
            viewModel.selectedFilter.bind { [unowned self] item in
                segmentView.selectedSegmentIndex = getIndex(of: item)
            }

            segmentView.rx.selectedSegmentIndex.bind { [unowned self, unowned viewModel] selected in
                let selectedWidth = segmentView.frame.width / CGFloat(viewModel.filtersList.value.count)
                let selectedFrame = CGRect(x: selectedWidth * CGFloat(selected), y: 0, width: selectedWidth, height: 44)
                scrollView.scrollRectToVisible(selectedFrame, animated: true)

                guard selected != 0 else { return viewModel.selectedFilter.accept(nil) }
                viewModel.selectedFilter.accept(viewModel.filtersList.value[selected - 1])
            }
        }
    }

    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()

        scrollView.contentInset.left = layoutMargins.left
        scrollView.contentInset.right = layoutMargins.right
    }
}

private extension BookmarksFilterHeaderCell {
    func getIndex(of item: ApiMangaBookmarkModel?) -> Int {
        guard let item else { return 0 }
        return (viewModel.filtersList.value.firstIndex(where: { $0.id == item.id }) ?? 0) + 1
    }
}
