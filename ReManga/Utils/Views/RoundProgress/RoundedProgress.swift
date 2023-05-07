//
//  RoundedProgress.swift
//  ReManga
//
//  Created by Даниил Виноградов on 07.05.2023.
//

import UIKit

@IBDesignable
public final class RoundedProgress: UIView {
    // MARK: - Public
    @IBInspectable
    public var progress: CGFloat {
        get { foregroundCircleView.progress }
        set { foregroundCircleView.progress = newValue }
    }

    @IBInspectable
    public var strokeWidth: CGFloat {
        get { foregroundCircleView.strokeWidth }
        set {
            backgroundCircleView.strokeWidth = newValue
            foregroundCircleView.strokeWidth = newValue
        }
    }

    @IBInspectable
    public var trackTint: UIColor {
        get { backgroundCircleView.tintColor }
        set { backgroundCircleView.tintColor = newValue }
    }

    // MARK: - Life cycle
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    // MARK: - Private constants
    private let defaultStrokeWidth: Double = 3
    private let backgroundCircleView = AnimatedCircle()
    private let foregroundCircleView = AnimatedCircle()
}

// MARK: - Private init
private extension RoundedProgress {
    func commonInit() {
        backgroundCircleView.progress = 1
        backgroundCircleView.tintColor = .gray

        backgroundCircleView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        foregroundCircleView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        backgroundCircleView.frame = bounds
        foregroundCircleView.frame = bounds

        addSubview(backgroundCircleView)
        addSubview(foregroundCircleView)

        strokeWidth = defaultStrokeWidth
    }
}
