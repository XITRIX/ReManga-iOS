//
//  IntExtensions.swift
//  ReManga
//
//  Created by Даниил Виноградов on 04.11.2021.
//

import UIKit

extension BinaryInteger {
    var degreesToRadians: CGFloat {
        return CGFloat(Int(self)) * .pi / 180
    }

    var text: String {
        "\(self)"
    }

    func cropText() -> String {
        if self >= 1000000 {
            return String(format: "%.1fM", Float(self) / 1000000)
        }
        if self >= 1000 {
            return String(format: "%.1fK", Float(self) / 1000)
        }
        return "\(self)"
    }
}
