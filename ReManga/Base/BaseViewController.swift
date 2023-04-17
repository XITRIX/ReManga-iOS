//
//  BaseViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 12.04.2023.
//

import MvvmFoundation
import UIKit

@MainActor
class BaseViewController<VM: BaseViewModelProtocol>: MvvmViewController<VM> {
    var overlayViewController: UIViewController? {
        didSet {
            if let oldValue {
                oldValue.willMove(toParent: nil)
                oldValue.view.removeFromSuperview()
                oldValue.removeFromParent()
            }

            if let overlayViewController {
                attachOverlayViewController(overlayViewController)
            }
        }
    }

    open func attachOverlayViewController(_ viewController: UIViewController) {
        addChild(viewController)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bind(in: disposeBag) {
            viewModel.state.bind { [unowned self] state in
                stateDidChange(state)
            }
        }
    }

    open func stateDidChange(_ state: ViewModelState) {
        switch state {
        case .default:
            overlayViewController = nil
        case .loading:
            overlayViewController = LoadingViewModel.resolveVC()
        case .error(let error, let task):
            overlayViewController = ErrorViewModel.resolveVC(with: (error, task))
        }
    }
}
