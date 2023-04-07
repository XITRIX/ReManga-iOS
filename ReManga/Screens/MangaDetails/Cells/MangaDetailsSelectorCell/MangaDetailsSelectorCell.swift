//
//  MangaDetailsSelectorCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 14.04.2023.
//

import UIKit
import MvvmFoundation

class MangaDetailsSelectorCell<VM: MangaDetailsSelectorViewModel>: MvvmCollectionViewCell<VM> {
    @IBOutlet private var segmentControl: UISegmentedControl!

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            viewModel.segments.bind { [unowned self] segments in
                segmentControl.removeAllSegments()
                for segment in segments.enumerated() {
                    segmentControl.insertSegment(withTitle: segment.element, at: segment.offset, animated: false)
                }
            }

            viewModel.selected <-> segmentControl.rx.selectedSegmentIndex 
        }
    }

}
