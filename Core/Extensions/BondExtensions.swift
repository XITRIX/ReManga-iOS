//
//  BondExtensions.swift
//  ReManga
//
//  Created by Даниил Виноградов on 05.11.2021.
//

import Foundation
import ReactiveKit
import Bond

extension UIButton {
    func bind(_ action: @escaping () -> ()) -> Disposable {
        self.reactive.tap.observeNext(with: action)
    }
}
