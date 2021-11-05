//
//  GradientView.swift
//  ReManga
//
//  Created by Даниил Виноградов on 04.11.2021.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    @IBInspectable
    var firstColor: UIColor = .white

    @IBInspectable
    var secondColor: UIColor = .white

    override public class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }

    init() {
        super.init(frame: .zero)
        updateColor()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updateColor()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
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
            firstColor.cgColor,
            secondColor.cgColor
        ]
    }
}
