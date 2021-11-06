//
//  Router.swift
//  DemoMVVM
//
//  Created by Даниил Виноградов on 03.11.2021.
//

import Foundation
import UIKit

class Router {
    private let container: Container
    private var map = [String: Any]()
    private var rootModel: String?

    init(container: Container) {
        self.container = container
    }

    func registerRoot(_ rootModel: MvvmViewModelProtocol.Type) {
        self.rootModel = "\(rootModel)"
    }

    func resolveRoot(in window: UIWindow) {
        if let rootModel = rootModel,
           let resolver = map["\(rootModel)"] {
            let viewModel = container.resolve(id: rootModel) as MvvmViewModelProtocol
            let vc = container.resolve(id: "\(resolver)") as MvvmViewControllerProtocol
            vc.setViewModel(viewModel)
            window.rootViewController = vc
        }
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
