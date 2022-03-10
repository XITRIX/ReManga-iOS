//
//  MvvmCollectionViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 04.11.2021.
//

import UIKit

class MvvmCollectionViewController<ViewModel: MvvmViewModelProtocol>: UICollectionViewController, MvvmViewControllerProtocol {
    var _viewModel: MvvmViewModelProtocol!
    var viewModel: ViewModel { _viewModel as! ViewModel }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.title.observeNext(with: { [unowned self] in title = $0 }).dispose(in: bag)
    }
}
