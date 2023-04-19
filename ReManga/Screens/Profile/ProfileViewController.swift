//
//  ProfileViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 18.04.2023.
//

import UIKit
import MvvmFoundation
import RxBiBinding

class ProfileViewController<VM: ProfileViewModel>: BaseViewController<VM> {
    @IBOutlet private var authButton: UIButton!
    @IBOutlet private var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))

        bind(in: disposeBag) {
            viewModel.auth <- authButton.rx.tap
            textField.rx.text <-> viewModel.authToken
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}
