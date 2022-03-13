//
//  MVVM.swift
//  ReManga
//
//  Created by Даниил Виноградов on 13.03.2022.
//

import Foundation
import MVVMFoundation

class MVVMCore: MVVM {
    override func registerContainer() {
        super.registerContainer()

        // Register Base Controllers
        container.register(type: UINavigationController.self) { BaseNavigationController() }

        // Register ViewModels
        container.register { RootSplitViewModel() }
        container.register { MainViewModel() }
        container.register { CatalogViewModel() }
        container.register { TitleViewModel() }
        container.register { ReaderViewModel() }
        container.register { SearchViewModel() }
        container.register { RootTabsViewModel() }
        container.register { CatalogFilterViewModel() }
        container.register { UserViewModel() }

        // Register ViewControllers
        container.register { RootSplitViewController() }
        container.register { MainViewController() }
        container.register { CatalogViewController() }
        container.register { TitleViewController() }
        container.register { ReaderViewController() }
        container.register { SearchViewController() }
        container.register { RootTabsViewController() }
        container.register { CatalogFilerViewController() }
        container.register { UserViewController() }
    }

    override func registerRouting() {
        super.registerRouting()
        
        // Register root ViewModel
        router.registerRoot(RootSplitViewModel.self)

        // Register navigation routing
        router.register(viewModel: RootSplitViewModel.self, viewController: RootSplitViewController.self)
        router.register(viewModel: MainViewModel.self, viewController: MainViewController.self)
        router.register(viewModel: CatalogViewModel.self, viewController: CatalogViewController.self)
        router.register(viewModel: TitleViewModel.self, viewController: TitleViewController.self)
        router.register(viewModel: ReaderViewModel.self, viewController: ReaderViewController.self)
        router.register(viewModel: SearchViewModel.self, viewController: SearchViewController.self)
        router.register(viewModel: RootTabsViewModel.self, viewController: RootTabsViewController.self)
        router.register(viewModel: CatalogFilterViewModel.self, viewController: CatalogFilerViewController.self)
        router.register(viewModel: UserViewModel.self, viewController: UserViewController.self)
    }
}
