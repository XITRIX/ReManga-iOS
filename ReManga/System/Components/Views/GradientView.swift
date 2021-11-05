//
//  GradientView.swift
//  ReManga
//
//  Created by Даниил Виноградов on 04.11.2021.
//

import UIKit

class GradientView: UIView {
    override public class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        updateColor()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateColor()
    }

    private func updateColor() {
        guard let gradientLayer = layer as? CAGradientLayer else {
            return
        }
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
    }
}
