//
//  RoundedProgressLayer.swift
//  ReManga
//
//  Created by Даниил Виноградов on 07.05.2023.
//

import UIKit

public final class RoundedProgressLayer: CAShapeLayer {
    // MARK: - Internal
    @NSManaged var progress: CGFloat
    @NSManaged var strokeWidth: CGFloat
    @NSManaged var color: CGColor

    // MARK: - Life cycle
    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // Whenever a new presentation layer is created, this function is called and makes a COPY of the object.
    override init(layer: Any) {
        super.init(layer: layer)
        if let layer = layer as? RoundedProgressLayer {
            progress = layer.progress
            strokeWidth = layer.strokeWidth
            color = layer.color
        }
    }

    override public class func needsDisplay(forKey key: String) -> Bool {
        if isAnimationKeySupported(key) {
            return true
        }
        return super.needsDisplay(forKey: key)
    }

    override public func action(forKey event: String) -> CAAction? {
        if RoundedProgressLayer.isAnimationKeySupported(event) {
            // Copy animation context and mutate as needed
            guard let animation = currentAnimationContext(in: self)?.copy() as? CABasicAnimation else {
                setNeedsDisplay()
                return nil
            }

            animation.keyPath = event
            if let presentation = presentation() {
                animation.fromValue = presentation.value(forKeyPath: event)
            }
            animation.toValue = nil
            return animation
        }

        return super.action(forKey: event)
    }
}

// MARK: - Private
private extension RoundedProgressLayer {
    class func isAnimationKeySupported(_ key: String) -> Bool {
        return key == #keyPath(progress) || key == #keyPath(strokeWidth) || key == #keyPath(color)
    }

    func currentAnimationContext(in layer: CALayer) -> CABasicAnimation? {
        /// The UIView animation implementation is private, so to check if the view is animating and
        /// get its property keys we can use the key "backgroundColor" since its been a property of
        /// UIView which has been forever and returns a CABasicAnimation.
        return action(forKey: #keyPath(backgroundColor)) as? CABasicAnimation
    }
}
