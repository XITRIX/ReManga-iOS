//
//  UIActivityIndicatorView+Extensions.swift
//  ReManga
//
//  Created by Даниил Виноградов on 21.04.2023.
//

import UIKit

extension UIActivityIndicatorView {
    func setAnimation(_ isAnimated: Bool) {
        isAnimated ? startAnimating() : stopAnimating()
    }
}
