//
//  SANavigationController.swift
//  iTorrent
//
//  Created by Daniil Vinogradov on 15.02.2020.
//  Copyright © 2020  XITRIX. All rights reserved.
//

import UIKit

/// Swipe Anywhere - to close view controller
public class SANavigationController: UINavigationController {
    var locker = true

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Glitchy behaviour on iOS less than 11
        if #available(iOS 11, *) {
            self.view.addGestureRecognizer(self.fullScreenPanGestureRecognizer)
            fullScreenPanGestureRecognizer.delegate = self
            delegate = self
        }
    }

    private lazy var fullScreenPanGestureRecognizer: UIPanGestureRecognizer = {
        let gestureRecognizer = UIPanGestureRecognizer()

        if let cachedInteractionController = self.value(forKey: "_cachedInteractionController") as? NSObject {
            let selector = Selector(("handleNavigationTransition:"))
            if cachedInteractionController.responds(to: selector) {
                gestureRecognizer.addTarget(cachedInteractionController, action: selector)
            }
        }

        return gestureRecognizer
    }()

    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        locker = true
    }
}

extension SANavigationController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        self.fullScreenPanGestureRecognizer.isEnabled = self.viewControllers.count > 1
    }
}

extension SANavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let controller = (viewControllers.last as? SAViewController)
        else { return false }
        
        if controller.navigationItem.leftBarButtonItem != nil {
            return false
        }

        if locker || controller.swipeAnywhereDisabled {
            return false
        }

        var isLeftToRight = true
        if #available(iOS 10.0, *) {
            isLeftToRight = view.effectiveUserInterfaceLayoutDirection == .leftToRight
        }

        if let pan = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = pan.velocity(in: view)
            if abs(velocity.x) > abs(velocity.y) {
                if isLeftToRight {
                    return velocity.x > 0
                } else {
                    return velocity.x < 0
                }
            }
        }

        return false
    }
}
