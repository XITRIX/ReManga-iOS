//
//  UIView+Extensions.swift
//  ReManga
//
//  Created by Даниил Виноградов on 23.04.2023.
//

import UIKit

extension UIView {
    var collectionHidden: Bool {
        get { isHidden }
        set {
            guard newValue != isHidden else { return }
            isHidden = newValue
            alpha = newValue ? 0 : 1
        }
    }
}
