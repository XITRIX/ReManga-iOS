//
//  MangaDetailsViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 30.06.2023.
//

import UIKit

class MangaDetailsViewController<VM: MangaDetailsViewModel>: BaseViewController<VM> {
    private lazy var thinVC = MangaDetailsViewController_Thin(viewModel: viewModel)
    private lazy var wideVC = MangaDetailsViewController_Wide(viewModel: viewModel)

    private var currentVC: UIViewController {
        thinVC
//        traitCollection.horizontalSizeClass == .compact ? thinVC : wideVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setToRoot(currentVC)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass
        else { return }

        setToRoot(currentVC)
    }
}

private extension UIViewController {
    func setToRoot(_ viewController: UIViewController) {
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }

        addChild(viewController)
        viewController.view.frame = view.frame
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)

        navigationItem.largeTitleDisplayMode = viewController.navigationItem.largeTitleDisplayMode
        navigationItem.scrollEdgeAppearance = viewController.navigationItem.scrollEdgeAppearance
        navigationItem.standardAppearance = viewController.navigationItem.standardAppearance
        navigationItem.titleView = viewController.navigationItem.titleView
    }
}
