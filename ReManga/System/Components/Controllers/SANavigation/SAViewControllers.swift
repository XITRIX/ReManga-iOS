//
//  SAViewController.swift
//  iTorrent
//
//  Created by Daniil Vinogradov on 01.04.2020.
//  Copyright © 2020  XITRIX. All rights reserved.
//

import UIKit

protocol NavigationProtocol {
    var swipeAnywhereDisabled: Bool { get }
    var toolBarIsHidden: Bool? { get }
    var navigationBarIsHidden: Bool? { get set }

    func updateNavigationControllerState(animated: Bool)
}

extension NavigationProtocol {
    var swipeAnywhereDisabled: Bool { false }
}

class SAViewController: UIViewController, NavigationProtocol {
    private var isPresented: Bool = false
    var swipeAnywhereDisabled: Bool {
        false
    }

    var toolBarIsHidden: Bool? {
        nil
    }

    var navigationBarIsHidden: Bool? = false {
        didSet {
            if isPresented {
                updateNavigationControllerState(animated: true)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        themeChanged()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavigationControllerState(animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let nav = navigationController as? SANavigationController,
           nav.viewControllers.last == self
        {
            nav.locker = false
        }
        isPresented = true
        updateNavigationControllerState(animated: false)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isPresented = false
    }

    func updateNavigationControllerState(animated: Bool = true) {
        if let toolBarIsHidden = toolBarIsHidden,
           navigationController?.isToolbarHidden != toolBarIsHidden
        {
            navigationController?.setToolbarHidden(toolBarIsHidden, animated: animated)
        }

        if let navigationBarIsHidden = navigationBarIsHidden,
           navigationController?.isNavigationBarHidden != navigationBarIsHidden
        {
            navigationController?.setNavigationBarHidden(navigationBarIsHidden, animated: animated)
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                themeChanged()
            }
        }
    }

    func themeChanged() {}
}

class SATableViewController: UITableViewController, NavigationProtocol {
    var swipeAnywhereDisabled: Bool {
        false
    }

    var toolBarIsHidden: Bool? {
        nil
    }

    var navigationBarIsHidden: Bool? = false

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let nav = navigationController as? SANavigationController,
           nav.viewControllers.last == self
        {
            nav.locker = false
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavigationControllerState()
    }

    func updateNavigationControllerState(animated: Bool = true) {
        if let toolBarIsHidden = toolBarIsHidden {
            navigationController?.setToolbarHidden(toolBarIsHidden, animated: animated)
        }

        if let navigationBarIsHidden = navigationBarIsHidden {
            navigationController?.setNavigationBarHidden(navigationBarIsHidden, animated: animated)
        }
    }
}
