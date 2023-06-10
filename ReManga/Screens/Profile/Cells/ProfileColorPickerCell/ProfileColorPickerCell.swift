//
//  ProfileColorPickerCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 01.06.2023.
//

import UIKit
import MvvmFoundation
import UIGradient

class ProfileColorPickerCell<VM: ProfileColorPickerViewModel>: MvvmCollectionViewListCell<VM> {
    @IBOutlet private var colorsStack: UIStackView!
    @IBOutlet private var scrollView: UIScrollView!
    private let colors: [UIColor] = [.systemBlue, .systemPurple, .systemPink, .systemRed, .systemOrange, .systemYellow, .systemGreen, .systemCyan]
    private let colorViewSize: Double = 38
    private lazy var delegates = Delegates(parent: self)

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

    @IBAction func colorPicker(_ sender: UIControl) {
        let vc = UIColorPickerViewController()
        vc.selectedColor = Properties.shared.tintColor
        vc.delegate = delegates
        viewController?.present(vc, animated: true)
    }
    
    @IBAction func gradientPicker(_ sender: UIControl) {
        Properties.shared.tintColor = .fromGradient(.berrySmoothie, frame: .init(x: 0, y: 0, width: 44, height: 44)) ?? .systemPink
    }

    @objc private func changeTintColor(_ sender: UIControl) {
        Properties.shared.tintColor = sender.backgroundColor!
    }
}

private extension ProfileColorPickerCell {
    func fillWithColors() {
        for color in colors {
            let view = makeColorView(color)
            view.addTarget(self, action: #selector(changeTintColor(_:)), for: .touchUpInside)
            colorsStack.addArrangedSubview(view)
        }

        for view in colorsStack.arrangedSubviews {
            view.layer.cornerRadius = colorViewSize / 2
            view.layer.borderWidth = 1
            view.borderColor = .label
        }
    }

    func makeColorView(_ color: UIColor) -> UIControl {
        let view = UIControl()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: colorViewSize),
            view.heightAnchor.constraint(equalToConstant: colorViewSize)
        ])

        return view
    }
}

extension ProfileColorPickerCell {
    class Delegates: DelegateObject<ProfileColorPickerCell>, UIColorPickerViewControllerDelegate {
        func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
            Properties.shared.tintColor = color
        }
    }
}
