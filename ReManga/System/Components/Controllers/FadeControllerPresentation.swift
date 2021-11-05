//
//  FadeControllerPresentation.swift
//  ReManga
//
//  Created by Даниил Виноградов on 05.11.2021.
//

import UIKit

class FadeControllerPresentation: NSObject {
    let animationDuration: Double
    let animationType: AnimationType

    init(duration: Double, type: AnimationType) {
        animationDuration = duration
        animationType = type
    }
}

extension FadeControllerPresentation {
    enum AnimationType {
        case present
        case dismiss
    }
}

extension FadeControllerPresentation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        animationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to),
              let fromVC = transitionContext.viewController(forKey: .from)
        else {
            transitionContext.completeTransition(false)
            return
        }

        switch animationType {
        case .present:
            transitionContext.containerView.addSubview(toVC.view)
            animate(with: transitionContext, view: toVC.view, reverce: false)
        case .dismiss:
            transitionContext.containerView.addSubview(fromVC.view)
            animate(with: transitionContext, view: fromVC.view, reverce: true)
        }
    }

    func animate(with transitionContext: UIViewControllerContextTransitioning, view: UIView, reverce: Bool) {
        view.alpha = reverce ? 1 : 0
        view.frame = view.superview!.bounds
        UIView.animate(withDuration: animationDuration) {
            view.alpha = reverce ? 0 : 1
        } completion: { done in
            transitionContext.completeTransition(done)
        }

    }

}
