//
//  MvvmViewControllerProtocol.swift
//  ReManga
//
//  Created by Даниил Виноградов on 04.11.2021.
//

import UIKit

protocol MvvmViewControllerProtocol: UIViewController {
    associatedtype ViewModel: MvvmViewModelProtocol

    var viewModel: ViewModel! { get set }
    func setViewModel(_ viewModel: ViewModel)
}

extension MvvmViewControllerProtocol {
    func setViewModel(_ viewModel: ViewModel) {
        guard self.viewModel == nil else { fatalError("viewModel cannot be set several times") }
        self.viewModel = viewModel
        self.viewModel.setAttachedView(self)
    }
}
