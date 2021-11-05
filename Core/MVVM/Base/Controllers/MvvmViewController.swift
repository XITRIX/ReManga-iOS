//
//  MvvmViewController.swift
//  DemoMVVM
//
//  Created by Даниил Виноградов on 02.11.2021.
//

import UIKit

class MvvmViewController<ViewModel: MvvmViewModelProtocol>: SAViewController, MvvmViewControllerProtocol {
    var viewModel: ViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.title.observeNext(with: { [unowned self] in title = $0 }).dispose(in: bag)
    }
}
