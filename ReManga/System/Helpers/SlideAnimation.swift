//
//  SlideAnimation.swift
//  ReManga
//
//  Created by Даниил Виноградов on 16.12.2021.
//

import UIKit
import MVVMFoundation

class SlideAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    var popStyle: Bool = false

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if popStyle {
            animatePop(using: transitionContext)
        } else {
            animatePush(using: transitionContext)
        }
    }

    func animatePush(using transitionContext: UIViewControllerContextTransitioning) {
        let fz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let tz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!

        let f = transitionContext.finalFrame(for: tz)

        let fOff = f.offsetBy(dx: f.width, dy: 0)
        tz.view.frame = fOff

        let ff = f.offsetBy(dx: -f.width/3, dy: 0)

        transitionContext.containerView.insertSubview(tz.view, aboveSubview: fz.view)

        let test = tz as? NavigationProtocol

        var snap: UIView?
        var ts: CGRect?

        var snap2: UIView?
        var ts2: CGRect?

        if let tbvc = tz.tabBarController,
           let lsnap = tbvc.tabBar.snapshotView(afterScreenUpdates: false),
           let btz = tz as? NavigationProtocol,
           btz.hidesBottomBar,
           tbvc.tabBar.isHidden == false
        {
            snap = lsnap
            transitionContext.containerView.insertSubview(lsnap, aboveSubview: fz.view)
            lsnap.frame.origin.y = transitionContext.containerView.frame.height - lsnap.frame.height
            tbvc.tabBar.isHidden = true
            ts = lsnap.frame.offsetBy(dx: -f.width/3, dy: 0)
        }

        if let nvc = tz.navigationController,
           let lsnap = nvc.navigationBar.snapshotView(afterScreenUpdates: false),
           let btz = tz as? NavigationProtocol,
           btz.hidesTopBar,
           nvc.navigationBar.isHidden == false
        {
            snap2 = lsnap
            transitionContext.containerView.insertSubview(lsnap, aboveSubview: fz.view)
            lsnap.frame = tz.navigationController!.navigationBar.frame
            nvc.navigationBar.isHidden = true
            ts2 = lsnap.frame.offsetBy(dx: -f.width/3, dy: 0)
        }

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: [.curveEaseOut],
            animations: {
                fz.view.frame = ff
                tz.view.frame = f

                if let ts = ts {
                    snap?.frame = ts
                }

                if let ts2 = ts2 {
                    snap2?.frame = ts2
                }
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
    }

    func animatePop(using transitionContext: UIViewControllerContextTransitioning) {
        let fz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let tz = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!

        let f = transitionContext.initialFrame(for: fz)
        let fOffPop = f.offsetBy(dx: f.width, dy: 0)

        let ff = f.offsetBy(dx: -f.width/3, dy: 0)
        tz.view.frame = ff

        transitionContext.containerView.insertSubview(tz.view, belowSubview: fz.view)

        var snap: UIView?
        var ts: CGRect?

        var snap2: UIView?
        var ts2: CGRect?


        tz.tabBarController?.tabBar.isHidden = false

        if let tbvc = tz.tabBarController,
           let lsnap = tbvc.tabBar.snapshotView(afterScreenUpdates: false),
           let bfz = fz as? NavigationProtocol,
           let btz = tz as? NavigationProtocol,
           bfz.hidesBottomBar,
           !btz.hidesBottomBar
        {
            snap = lsnap
            transitionContext.containerView.insertSubview(lsnap, aboveSubview: tz.view)
            ts = lsnap.frame
            ts?.origin.y = transitionContext.containerView.frame.height - lsnap.frame.height
            lsnap.isHidden = false
            lsnap.frame = ts!.offsetBy(dx: -f.width/3, dy: 0)

            DispatchQueue.main.async {
                tbvc.tabBar.isHidden = true
            }
        }

        if let nvc = tz.navigationController,
           let lsnap = nvc.navigationBar.snapshotView(afterScreenUpdates: false),
           let bfz = fz as? NavigationProtocol,
           let btz = tz as? NavigationProtocol,
           bfz.hidesTopBar,
           !btz.hidesTopBar
        {
            snap2 = lsnap
            transitionContext.containerView.insertSubview(lsnap, aboveSubview: tz.view)
            ts2 = lsnap.frame
            ts2?.origin.y = 0
            lsnap.isHidden = false
            lsnap.frame = ts!.offsetBy(dx: -f.width/3, dy: 0)

            DispatchQueue.main.async {
                nvc.navigationBar.isHidden = true
            }
        }

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: [.curveEaseOut],
            animations: {
                tz.view.frame = f
                fz.view.frame = fOffPop
                if let ts = ts {
                    snap?.frame = ts
                }
                if let ts2 = ts2 {
                    snap2?.frame = ts2
                }
            }, completion: { _ in
                if tz.tabBarController?.tabBar.isHidden == true {
                    tz.tabBarController?.tabBar.isHidden = false
                }
                if tz.navigationController?.navigationBar.isHidden == true {
                    tz.navigationController?.navigationBar.isHidden = false
                }
                snap?.removeFromSuperview()
                snap2?.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
    }
}
