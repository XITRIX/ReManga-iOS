//
//  MangaPaymentViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 18.04.2023.
//

import UIKit
import MvvmFoundation

class MangaPaymentViewController<VM: MangaPaymentViewModel>: BaseViewController<VM> {
    @IBOutlet private var costLabel: UILabel!
    @IBOutlet private var payButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        bind(in: disposeBag) {
            costLabel.rx.text <- viewModel.cost
            viewModel.pay <- payButton.rx.tap
        }
    }

}
