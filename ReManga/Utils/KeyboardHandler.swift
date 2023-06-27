//
//  KeyboardHandler.swift
//  ReManga
//
//  Created by Даниил Виноградов on 12.04.2023.
//

import UIKit

struct KeyboardStatus {
    var oldFrame: CGRect
    var newFrame: CGRect
    var bottomOverlayHeight: Double
    var animationDuration: Double
    var animationCurve: UIView.AnimationOptions
}

class KeyboardHandler {
    var onKeyboardWillChangeFrame: ((KeyboardStatus) -> Void)?
    var extraOffset: Double = 0
    private(set) var requiredBottomInset: Double = 0

    init(_ scrollView: UIScrollView) {
        self.scrollView = scrollView
        registerForKeyboardNotifications()
    }

    deinit {
        unregisterKeyboardNotifications()
    }

    private let scrollView: UIScrollView
    private var lastExtraContentOffset: Double = 0
}

private extension KeyboardHandler {
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func onKeyboardAppear(_ notification: NSNotification) {
        let info = notification.userInfo!
        let oldRect = info[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
        let rect = info[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let animationCurve = info[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt

        // Convert the animation curve constant to animation options.
        let animationOptions = UIView.AnimationOptions(rawValue: animationCurve << 16)

        let scrollFrame = CGRect(origin: scrollView.superview?.convert(scrollView.frame.origin, to: scrollView.window) ?? .zero, size: scrollView.frame.size)


        let old = max(0, scrollFrame.maxY - scrollView.layoutMargins.bottom - oldRect.minY)
        lastExtraContentOffset = scrollView.contentInset.bottom - old

        requiredBottomInset = max(0, scrollFrame.maxY - scrollView.layoutMargins.bottom - rect.minY)
        print("-=-=-=-= offset: \(requiredBottomInset)")

        let insets = UIEdgeInsets(top: 0, left: 0, bottom: requiredBottomInset, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets

        let bottomOverlayHeight = max(0, scrollFrame.maxY - rect.minY)

        onKeyboardWillChangeFrame?(.init(oldFrame: oldRect,
                                         newFrame: rect,
                                         bottomOverlayHeight: bottomOverlayHeight,
                                         animationDuration: duration,
                                         animationCurve: animationOptions))
    }
}
