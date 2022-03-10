//
//  UIViewExtensions.swift
//  ReManga
//
//  Created by Даниил Виноградов on 04.11.2021.
//

import UIKit

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

    var safeFrame: CGRect {
        var frame = frame
        frame.size.height = frame.height - safeAreaInsets.top - safeAreaInsets.bottom
        frame.size.width = frame.width - safeAreaInsets.left - safeAreaInsets.right
        frame.origin.y = frame.origin.y + safeAreaInsets.top
        frame.origin.x = frame.origin.x + safeAreaInsets.left
        return frame
    }
}
