//
//  ProfileColorPickerCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 01.06.2023.
//

import UIKit
import MvvmFoundation

class ProfileColorPickerCell<VM: ProfileColorPickerViewModel>: MvvmCollectionViewListCell<VM> {
    @IBOutlet private var colorsStack: UIStackView!
    @IBOutlet private var scrollView: UIScrollView!
    private let colors: [UIColor] = [.systemBlue, .systemPurple, .systemPink, .systemRed, .systemOrange, .systemYellow, .systemGreen, .systemCyan]
    private let colorViewSize: Double = 38

    override func initSetup() {
        fillWithColors()
    }

    override func setup(with viewModel: VM) {

    }

    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        scrollView.contentInset.left = layoutMargins.left
        scrollView.contentInset.right = layoutMargins.right
    }


    @objc private func changeTintColor(_ sender: UIControl) {
        Properties.shared.tintColor = sender.backgroundColor!
    }
}

private extension ProfileColorPickerCell {
    func fillWithColors() {
        for color in colors {
            colorsStack.addArrangedSubview(makeColorView(color))
        }
    }

    func makeColorView(_ color: UIColor) -> UIView {
        let view = UIControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color
        view.layer.cornerRadius = colorViewSize / 2
        view.layer.borderWidth = 1
        view.borderColor = .label
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: colorViewSize),
            view.heightAnchor.constraint(equalToConstant: colorViewSize)
        ])
        view.addTarget(self, action: #selector(changeTintColor(_:)), for: .touchUpInside)
        return view
    }
}
