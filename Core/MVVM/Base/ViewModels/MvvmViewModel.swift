//
//  MvvmViewModel.swift
//  DemoMVVM
//
//  Created by Даниил Виноградов on 02.11.2021.
//

import Bond
import ReactiveKit
import UIKit

protocol MvvmViewModelProtocol: DisposeBagProvider {
    var title: Observable<String?> { get }
    var attachedView: UIViewController! { get }
    var state: Observable<MvvmViewModelState> { get }

    func setAttachedView(_ viewController: UIViewController)
    func appear()
}

class MvvmViewModel: MvvmViewModelProtocol {
    let bag = DisposeBag()
    let title = Observable<String?>(nil)
    let state = Observable<MvvmViewModelState>(.done)

    func setAttachedView(_ viewController: UIViewController) {
        guard attachedView == nil else { fatalError("attachedView cannot be reattached") }
        attachedView = viewController
    }

    func appear() {}

    private(set) weak var attachedView: UIViewController!

    required init() {}
}
