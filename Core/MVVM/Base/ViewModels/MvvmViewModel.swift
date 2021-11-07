//
//  MvvmViewModel.swift
//  DemoMVVM
//
//  Created by Даниил Виноградов on 02.11.2021.
//

import Bond
import ReactiveKit
import UIKit

enum MvvmViewModelState: Equatable {
    case done
    case processing
    case error(Error)

    static func == (lhs: MvvmViewModelState, rhs: MvvmViewModelState) -> Bool {
        switch (lhs, rhs) {
        case (.done, .done):
            return true
        case (.processing, .processing):
            return true
        case (.error(let err1), .error(let err2)):
            return err1.localizedDescription == err2.localizedDescription
        default:
            return false
        }
    }
}

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
