//
//  GradientView.swift
//  ReManga
//
//  Created by Даниил Виноградов on 14.04.2023.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    @IBInspectable
    var startColor: UIColor = .white {
        didSet {
            updateColors()
        }
    }

    @IBInspectable
    var endColor: UIColor = .black {
        didSet {
            updateColors()
        }
    }

    private var gradientLayer: CAGradientLayer {
        layer as! CAGradientLayer
    }

    override open class var layerClass: AnyClass {
        CAGradientLayer.classForCoder()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateColors()
    }

    private func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateColors()
    }
}
