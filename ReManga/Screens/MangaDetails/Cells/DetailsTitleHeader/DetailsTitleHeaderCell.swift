//
//  DetailsTitleHeaderCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 13.04.2023.
//

import MvvmFoundation
import UIKit

class DetailsTitleHeaderCell<VM: DetailsTitleHeaderViewModel>: MvvmCollectionViewCell<VM> {
    @IBOutlet private var backlayerView: UIView!
    @IBOutlet private var title: UILabel!
    @IBOutlet private var detail: UILabel!
    @IBOutlet private var capView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.preservesSuperviewLayoutMargins = true

        capView.layer.cornerRadius = 16
        capView.layer.cornerCurve = .continuous
        capView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
//            title.rx.text <- viewModel.title
            detail.rx.text <- viewModel.detail
            viewModel.title.bind { [unowned self] text in
                title.text = text
            }
        }
    }
}
