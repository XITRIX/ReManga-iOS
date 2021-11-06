//
//  MVVM.swift
//  DemoMVVM
//
//  Created by Даниил Виноградов on 03.11.2021.
//

import Foundation

class MVVM {
    static let shared = MVVM()

    let container: Container
    var router: Router! {
        container.resolve(type: Router.self)
    }

    private init() {
        container = Container()

        registerContainer()
        registerRouting()
    }
}

extension MVVM {
    func registerContainer() {
        // Register services
        container.registerSingleton { Router(container: self.container) }

        // Register ViewModels
        container.register() { CatalogViewModel() }
        container.register() { TitleViewModel() }
        container.register() { ReaderViewModel() }
        container.register() { SearchViewModel() }
        container.register() { RootTabsViewModel() }

        // Register ViewControllers
        container.register() { CatalogViewController() }
        container.register() { TitleViewController() }
        container.register() { ReaderViewController() }
        container.register() { SearchViewController() }
        container.register() { RootTabsViewController() }
    }

    func registerRouting() {
        router.registerRoot(RootTabsViewModel.self)

        router.register(viewModel: CatalogViewModel.self, viewController: CatalogViewController.self)
        router.register(viewModel: TitleViewModel.self, viewController: TitleViewController.self)
        router.register(viewModel: ReaderViewModel.self, viewController: ReaderViewController.self)
        router.register(viewModel: SearchViewModel.self, viewController: SearchViewController.self)
        router.register(viewModel: RootTabsViewModel.self, viewController: RootTabsViewController.self)

//        let a: [MvvmViewControllerProtocol] = [CatalogViewController()]
    }
}
