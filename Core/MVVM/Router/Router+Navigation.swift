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

    func dismiss<FVM: MvvmViewModelProtocol>(from fromViewModel: FVM, completion: (() -> ())? = nil) {
        guard let fvc = fromViewModel.attachedView
        else { return }

        if fvc.isModal {
            fvc.dismiss(animated: true, completion: completion)
        } else {
            fvc.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - MvvmViewModel
extension Router {
    func navigate<FVM: MvvmViewModelProtocol, TVM: MvvmViewModel>(from fromViewModel: FVM, to targetViewModel: TVM.Type, with type: NavigationType) {
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

    func navigate<M, FVM: MvvmViewModelProtocol, TVM: MvvmViewModelWith<M>>(from fromViewModel: FVM, to targetViewModel: TVM.Type, prepare model: M, with type: NavigationType) {
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
                let nvc = BaseNavigationController(rootViewController: vc)
                fvc.present(nvc, animated: true)
            } else {
                fvc.present(vc, animated: true)
            }
        }
    }
}
