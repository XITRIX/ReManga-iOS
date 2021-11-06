//
//  MvvmTabsViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 06.11.2021.
//

import UIKit
import CoreMedia

class MvvmTabsViewController<ViewModel: MvvmTabsViewModelProtocol>: UITabBarController, MvvmViewControllerProtocol {
    var _viewModel: MvvmViewModelProtocol!
    var viewModel: ViewModel { _viewModel as! ViewModel }
    private var shown = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !shown {
            shown = true

            viewModel.viewModels.observeNext { [unowned self] viewModels in
                let viewControllers = viewModels.collection.map { model -> UIViewController in
                    let vc = model.item.resolveView()
                    let nvc = BaseNavigationController(rootViewController: vc)
                    nvc.tabBarItem.title = model.title
                    nvc.tabBarItem.image = model.image
                    nvc.tabBarItem.selectedImage = model.selectedImage
                    return nvc
                }
                
                setViewControllers(viewControllers, animated: true)
            }.dispose(in: bag)
        }
    }
}
