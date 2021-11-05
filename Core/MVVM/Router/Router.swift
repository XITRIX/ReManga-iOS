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

    func register<VM: MvvmViewModelProtocol, VC: MvvmViewController<VM>>(viewModel: VM.Type, viewController: VC.Type) {
        map["\(viewModel)"] = viewController
    }

    func resolve<VM: MvvmViewModelProtocol, VC: MvvmViewController<VM>>(viewModel: VM.Type) -> VC {
        if let resolver = map["\(viewModel)"] as? VC.Type {
            let viewModel = container.resolve(type: VM.self)
            let vc = container.resolve(type: resolver.self)
            vc.setViewModel(viewModel)
            return vc
        }
        fatalError("\(viewModel) is not registered")
    }

    func resolve<M, VM: MvvmViewModelWithProtocol, VC: MvvmViewController<VM>>(viewModel: VM.Type, prepare model: M) -> VC where VM.Model == M  {
        if let resolver = map["\(viewModel)"] as? VC.Type {
            let viewModel = container.resolve(type: VM.self)
            let vc = container.resolve(type: resolver.self)
            viewModel.prepare(with: model)
            vc.setViewModel(viewModel)
            return vc
        }
        fatalError("\(viewModel) is not registered")
    }
}
