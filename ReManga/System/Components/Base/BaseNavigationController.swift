//
//  BaseNavigationController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 05.11.2021.
//

import UIKit

class BaseNavigationController: SANavigationController {
    let animation = SlideAnimation()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.prefersLargeTitles = true
    }

//    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        animation.popStyle = operation == .pop
//        return animation
//    }
}
