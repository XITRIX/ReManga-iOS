//
//  MvvmSplitViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 11.12.2021.
//

import UIKit

class MvvmSplitViewController<ViewModel: MvvmSplitViewModelProtocol>: UISplitViewController, MvvmViewControllerProtocol, UISplitViewControllerDelegate {
    var _viewModel: MvvmViewModelProtocol!
    var viewModel: ViewModel { _viewModel as! ViewModel }

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        preferredDisplayMode = .oneBesideSecondary
        viewControllers.append(viewModel.primaryViewModel.resolveView())
        if let secondary = viewModel.secondaryViewModel {
            viewControllers.append(secondary.resolveView())
        } else {
            viewControllers.append(UINavigationController())
        }
    }

    override func showDetailViewController(_ vc: UIViewController, sender: Any?) {
        if isCollapsed {
            guard let from = sender as? UIViewController
            else { return }

            from.show(vc, sender: sender)
        } else {
            guard viewControllers.count > 0,
                  let nvc = viewControllers[1] as? UINavigationController
            else { return }

            nvc.setViewControllers([vc], animated: false)
        }
    }

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if let snvc = secondaryViewController as? UINavigationController
        {
            primaryViewController.navigationController?.viewControllers.append(contentsOf: snvc.viewControllers)
        }
        return true
    }

    func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
        guard let nvc = primaryViewController.navigationController
        else { return nil }

        var controllers = nvc.viewControllers
        var firstControllersStack = [UIViewController]()

        while !controllers.isEmpty {
            if controllers.first?.isSecondary == true { break }
            firstControllersStack.append(controllers.remove(at: 0))
        }

        nvc.setViewControllers(firstControllersStack, animated: false)

        let snvc = BaseNavigationController()
        snvc.view.backgroundColor = .systemBackground
        snvc.setViewControllers(controllers, animated: false)
        return snvc
    }
}
