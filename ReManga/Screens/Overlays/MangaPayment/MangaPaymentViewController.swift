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
            payButton.rx.tap.bind { [unowned self] _ in
                let alert = UIAlertController(title: "Подтверждение оплаты", message: "С вашего счёта будет списано \(viewModel.model.price.value ?? "")", preferredStyle: .alert)
                alert.addAction(.init(title: "Закрыть", style: .cancel))
                alert.addPreferredAction(.init(title: "Оплатить", style: .destructive, handler: { [unowned self] _ in
                    viewModel.pay()
                }))
                present(alert, animated: true)
            }
        }
    }

}

extension UIAlertController {
    func addPreferredAction(_ action: UIAlertAction) {
        addAction(action)
        preferredAction = action
    }
}
