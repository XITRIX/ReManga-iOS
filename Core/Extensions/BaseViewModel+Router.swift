//
//  BaseViewModel+Router.swift
//  DemoMVVM
//
//  Created by Даниил Виноградов on 04.11.2021.
//

import Foundation

extension MvvmViewModel {
    func navigate<TVM: MvvmViewModel>(to targetViewModel: TVM.Type, with type: Router.NavigationType = .push) {
        MVVM.shared.router.navigate(from: self, to: targetViewModel, with: type)
    }

    func navigate<M, TVM: MvvmViewModelWith<M>>(to targetViewModel: TVM.Type, prepare model: M, with type: Router.NavigationType = .push) {
        MVVM.shared.router.navigate(from: self, to: targetViewModel, prepare: model, with: type)
    }

    func dismiss() {
        attachedView.dismiss(animated: true)
    }
}
