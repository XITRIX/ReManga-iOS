//
//  Router.swift
//  DemoMVVM
//
//  Created by Даниил Виноградов on 03.11.2021.
//

import Foundation

class Router {
    private let container: Container
    private var map = [String: Any]()

    init(container: Container) {
        self.container = container
    }
}

// MARK: - MvvmViewController
extension Router {
    func register<VM: MvvmViewModelProtocol, VC: MvvmViewControllerProtocol>(viewModel: VM.Type, viewController: VC.Type) {
        map["\(viewModel)"] = viewController
    }

    func resolve<VM: MvvmViewModelProtocol>(viewModel: VM.Type) -> MvvmViewControllerProtocol {
        if let resolver = map["\(viewModel)"] {
            let viewModel = container.resolve(type: viewModel)
            let vc = container.resolve(id: "\(resolver)") as MvvmViewControllerProtocol
            vc.setViewModel(viewModel)
            return vc
        }
        fatalError("\(viewModel) is not registered")
    }

    func resolve<M, VM: MvvmViewModelWithProtocol>(viewModel: VM.Type, prepare model: M) -> MvvmViewControllerProtocol where VM.Model == M  {
        if let resolver = map["\(viewModel)"] {
            let viewModel = container.resolve(type: VM.self)
            let vc = container.resolve(id: "\(resolver)") as MvvmViewControllerProtocol
            viewModel.prepare(with: model)
            vc.setViewModel(viewModel)
            return vc
        }
        fatalError("\(viewModel) is not registered")
    }
}
