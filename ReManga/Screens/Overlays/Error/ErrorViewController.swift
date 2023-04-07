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

    override func viewDidLoad() {
        super.viewDidLoad()

        bind(in: disposeBag) {
            errorText.rx.text <- viewModel.error
        }
    }


}
