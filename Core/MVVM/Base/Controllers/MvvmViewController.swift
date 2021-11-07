//
//  MvvmViewController.swift
//  DemoMVVM
//
//  Created by Даниил Виноградов on 02.11.2021.
//

import UIKit

class MvvmViewController<ViewModel: MvvmViewModelProtocol>: SAViewController, MvvmViewControllerProtocol {
    var _viewModel: MvvmViewModelProtocol!
    var viewModel: ViewModel { _viewModel as! ViewModel }
    var overlay: UIViewController? {
        didSet { updateOverlay(oldValue) }
    }

    @available(*, unavailable)
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.appear()
        setupView()
        binding()
    }

    func setupView() {}
    func binding() {
        viewModel.title.observeNext(with: { [unowned self] in title = $0 }).dispose(in: bag)
        viewModel.state.observeNext(with: viewModelStateChanged).dispose(in: bag)
    }

    func viewModelStateChanged(_ state: MvvmViewModelState) {
        switch state {
        case .done:
            overlay = nil
        case .processing:
            overlay = LoadingOverlayViewController(backgroundColor: view.backgroundColor)
        case .error(_):
            overlay = nil
        }
    }

    func updateOverlay(_ old: UIViewController?) {
        if overlay == old { return }

        old?.remove()
        overlay?.add(to: self)
    }
}
