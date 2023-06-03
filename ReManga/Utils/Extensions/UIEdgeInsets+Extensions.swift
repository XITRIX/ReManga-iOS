//
//  UIEdgeInsets+Extensions.swift
//  ReManga
//
//  Created by Даниил Виноградов on 03.06.2023.
//

import UIKit

extension UIEdgeInsets {
    static func -(lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
        var res = lhs
        
        res.left -= rhs.left
        res.right -= rhs.right
        res.top -= rhs.top
        res.bottom -= rhs.bottom

        return res
    }
}
