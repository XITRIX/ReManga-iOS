//
//  ErrorViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 12.04.2023.
//

import UIKit
import MvvmFoundation

class ErrorViewController<VM: ErrorViewModel>: MvvmViewController<VM> {
    @IBOutlet private var errorText: UILabel!
    @IBOutlet private var retryButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        bind(in: disposeBag) {
            errorText.rx.text <- viewModel.error
            retryButton.rx.isHidden <- viewModel.task.map { $0 == nil }
            retryButton.rx.tap.bind { [unowned self] _ in
                _ = viewModel.task.value?()
            }
        }
    }

}
