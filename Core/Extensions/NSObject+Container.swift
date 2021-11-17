//
//  MvvmViewController+Router.swift
//  ReManga
//
//  Created by Даниил Виноградов on 10.11.2021.
//

import Foundation

extension NSObject {
    static func resolve() -> Self {
        MVVM.shared.container.resolve()
    }
}
