//
//  UIButton.swift
//  ReManga
//
//  Created by Даниил Виноградов on 18.04.2023.
//

import UIKit

extension UIButton.Configuration {
    func toFilled() -> Self {
        var current = UIButton.Configuration.filled()
        current.buttonSize = buttonSize
        current.title = title
        current.image = image
        return current
    }

    func toTinted() -> Self {
        var current = UIButton.Configuration.tinted()
        current.buttonSize = buttonSize
        current.title = title
        current.image = image
        return current
    }
}
