//
//  UIViewControllerExtensions.swift
//  ReManga
//
//  Created by Даниил Виноградов on 06.11.2021.
//

import ReactiveKit
import UIKit

extension UIViewController {
    func add(to viewController: UIViewController, in view: UIView? = nil) {
        viewController.addChild(self)
        self.view.frame = viewController.view.bounds
        self.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        if let view = view {
            view.addSubview(view)
        } else {
            viewController.view.addSubview(self.view)
        }
        self.didMove(toParent: viewController)
    }

    func insert(to viewController: UIViewController, at: Int, in view: UIView? = nil) {
        viewController.addChild(self)
        if let view = view {
            view.insertSubview(self.view, at: at)
            self.view.frame = view.bounds
        } else {
            viewController.view.insertSubview(self.view, at: at)
            self.view.frame = viewController.view.bounds
        }
        self.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.didMove(toParent: viewController)
    }

    func remove() {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }

    var isModal: Bool {
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController

        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }

    func smoothlyDeselectRows(in tableView: UITableView?) {
        // Get the initially selected index paths, if any
        let selectedIndexPaths = tableView?.indexPathsForSelectedRows ?? []

        // Grab the transition coordinator responsible for the current transition
        if let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: { context in
                selectedIndexPaths.forEach {
                    tableView?.deselectRow(at: $0, animated: context.isAnimated)
                }
            }) { context in
                if context.isCancelled {
                    selectedIndexPaths.forEach {
                        tableView?.selectRow(at: $0, animated: false, scrollPosition: .none)
                    }
                }
            }
        } else { // If this isn't a transition coordinator, just deselect the rows without animating
            selectedIndexPaths.forEach {
                tableView?.deselectRow(at: $0, animated: false)
            }
        }
    }
}

@resultBuilder
enum BindingBuilder {
    static func buildBlock() -> [Disposable] { [] }

    static func buildBlock(_ components: Disposable...) -> [Disposable] {
        components
    }

    static func buildArray(_ components: [[Disposable]]) -> [Disposable] {
        components.flatMap { $0 }
    }
}

extension UIViewController {
    func bindingContext(@BindingBuilder _ content: () -> [Disposable]) {
        content().forEach { $0.dispose(in: bag) }
    }
}

extension UIViewController {
    private enum AssociatedKey {
        static var viewExtension = "isSecondaryViewExtension"
    }

    var isSecondary: Bool? {
        get {
            objc_getAssociatedObject(self, &AssociatedKey.viewExtension) as? Bool
        }

        set {
            objc_setAssociatedObject(self, &AssociatedKey.viewExtension, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
