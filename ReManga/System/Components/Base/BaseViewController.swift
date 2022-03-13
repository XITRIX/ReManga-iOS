//
//  BaseViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 05.11.2021.
//

import Foundation
import MVVMFoundation

class BaseViewController<ViewModel: MvvmViewModel>: SAViewController<ViewModel> {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Large title dirty fix
        navigationController?.view.setNeedsLayout()
        navigationController?.view.layoutIfNeeded()
    }
}
