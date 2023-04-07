//
//  KeyboardHandler.swift
//  ReManga
//
//  Created by Даниил Виноградов on 12.04.2023.
//

import UIKit

class KeyboardHandler {
    init(_ scrollView: UIScrollView) {
        self.scrollView = scrollView
        registerForKeyboardNotifications()
    }

    deinit {
        unregisterKeyboardNotifications()
    }

    private let scrollView: UIScrollView
    private var lastContentOffset: Double = 0
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
        let rect: CGRect = info[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect

        let scrollFrame = CGRect(origin: scrollView.superview?.convert(scrollView.frame.origin, to: scrollView.window) ?? .zero, size: scrollView.frame.size)
        let inset = max(0, scrollFrame.maxY - scrollView.layoutMargins.bottom - rect.minY)

        let insets = UIEdgeInsets(top: 0, left: 0, bottom: inset, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
    }
}
