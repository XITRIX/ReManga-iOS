//
//  MvvmViewModel.swift
//  DemoMVVM
//
//  Created by Даниил Виноградов on 02.11.2021.
//

import UIKit
import ReactiveKit
import Bond

protocol MvvmViewModelProtocol: DisposeBagProvider {
    var title: Observable<String?> { get }
    var attachedView: UIViewController! { get }

    func setAttachedView(_ viewController: UIViewController)
}

class MvvmViewModel: MvvmViewModelProtocol {
    let bag = DisposeBag()
    let title = Observable<String?>(nil)

    func setAttachedView(_ viewController: UIViewController) {
        guard attachedView == nil else { fatalError("attachedView cannot be reattached") }
        attachedView = viewController
    }

    private(set) weak var attachedView: UIViewController!

    required init() {}
}
