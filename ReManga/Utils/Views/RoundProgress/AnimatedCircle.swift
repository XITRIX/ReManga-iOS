//
//  RoundProgress.swift
//  ReManga
//
//  Created by Даниил Виноградов on 07.05.2023.
//

import UIKit

@IBDesignable
internal final class AnimatedCircle: UIView {
    // MARK: - Public
    @IBInspectable
    public dynamic var progress: CGFloat {
        get { progressLayer.progress }
        set { progressLayer.progress = newValue }
    }

    @IBInspectable
    public dynamic var strokeWidth: CGFloat {
        get { progressLayer.strokeWidth }
        set { progressLayer.strokeWidth = newValue }
    }

    // MARK: - Life cycle
    init() {
        super.init(frame: .zero)
        commonInit()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override public class var layerClass: AnyClass {
        return RoundedProgressLayer.self
    }

    override public func tintColorDidChange() {
        super.tintColorDidChange()
        progressLayer.color = tintColor.cgColor
    }

    override public func display(_ layer: CALayer) {
        guard let presentationLayer = (layer.presentation() ?? layer) as? RoundedProgressLayer
        else { return }

        progressLayer.path = makeProgressBezierPath()
        progressLayer.strokeEnd = presentationLayer.progress
        progressLayer.lineWidth = presentationLayer.strokeWidth
        progressLayer.strokeColor = presentationLayer.color
    }

    // MARK: - Private constants
    private let defaultStrokeWidth: Double = 3
}

// MARK: - Private
private extension AnimatedCircle {
    var progressLayer: RoundedProgressLayer {
        guard let layer = layer as? RoundedProgressLayer
        else { fatalError("Сould not cast \(layer.self) into \(RoundedProgressLayer.self)") }

        return layer
    }

    func commonInit() {
        strokeWidth = defaultStrokeWidth
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.strokeStart = .zero
        progressLayer.strokeEnd = progress
    }

    func makeProgressBezierPath() -> CGPath {
        // Inset to make stroke inline
        let path = UIBezierPath(ovalIn: bounds.insetBy(dx: strokeWidth / 2, dy: strokeWidth / 2))
        // Rotate counterclockwise on 90 degree
        path.apply(CGAffineTransform(rotationAngle: Math.degreeToRadian(-90)))
        // Move down to compensate rotation with anchor in (0, 0)
        path.apply(CGAffineTransform(translationX: 0, y: bounds.height))

        return path.cgPath
    }
}
