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

    var viewController: UIViewController? {
        var nextResponder = next

        while nextResponder != nil {
            if let nextResponder = nextResponder as? UIViewController {
                return nextResponder
            }

            nextResponder = nextResponder?.next
        }

        return nil
    }
}
