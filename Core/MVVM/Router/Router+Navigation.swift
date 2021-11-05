//
//  Router+Navigation.swift
//  DemoMVVM
//
//  Created by Даниил Виноградов on 04.11.2021.
//

import UIKit

extension Router {
    enum NavigationType {
        case push
        case detail
        case modal(wrapInNavigation: Bool)
    }

    func navigate<FVM: MvvmViewModel, TVM: MvvmViewModel>(from fromViewModel: FVM, to targetViewModel: TVM.Type, with type: NavigationType) {
        guard let fvc = fromViewModel.attachedView
        else { return }

        let vc = resolve(viewModel: TVM.self)

        switch type {
        case .push:
            fvc.show(vc, sender: fvc)
        case .detail:
            fvc.showDetailViewController(vc, sender: fvc)
        case .modal:
            fvc.present(vc, animated: true)
        }
    }

    func navigate<M, FVM: MvvmViewModel, TVM: MvvmViewModelWith<M>>(from fromViewModel: FVM, to targetViewModel: TVM.Type, prepare model: M, with type: NavigationType) {
        guard let fvc = fromViewModel.attachedView
        else { return }
        
        let vc = resolve(viewModel: TVM.self, prepare: model)

        switch type {
        case .push:
            fvc.show(vc, sender: fvc)
        case .detail:
            fvc.showDetailViewController(vc, sender: fvc)
        case .modal(let wrapInNavigation):
            if wrapInNavigation {
                let nvc = UINavigationController(rootViewController: vc)
                fvc.present(nvc, animated: true)
            } else {
                fvc.present(vc, animated: true)
            }
        }
    }
}
