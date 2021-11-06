//
//  MvvmViewControllerProtocol.swift
//  ReManga
//
//  Created by Даниил Виноградов on 04.11.2021.
//

import UIKit

protocol MvvmViewControllerProtocol: UIViewController {
    var _viewModel: MvvmViewModelProtocol! { get set }
    func setViewModel(_ viewModel: MvvmViewModelProtocol)
}

extension MvvmViewControllerProtocol {
    func setViewModel(_ viewModel: MvvmViewModelProtocol) {
        guard self._viewModel == nil else { fatalError("viewModel cannot be set several times") }
        self._viewModel = viewModel
        self._viewModel.setAttachedView(self)
    }
}
