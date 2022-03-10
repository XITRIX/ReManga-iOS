//
//  LongSegmentView.swift
//  ReManga
//
//  Created by Даниил Виноградов on 14.12.2021.
//

import UIKit

@IBDesignable
class LongSegmentView: NibLoadableView {
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var selectorView: UIView!

    override func defaultInit() {
        super.defaultInit()

        for i in 0 ..< 7 {
            stackView.addArrangedSubview(makePart(with: "Test \(i+1)"))
        }

        DispatchQueue.main.async {
            var frame = self.stackView.subviews[0].frame
            frame.origin.x += 2
            frame.origin.y += 2
            frame.size.width -= 4
            frame.size.height -= 4
            self.selectorView.frame = frame
        }
    }

    func makePart(with text: String) -> UIView {
        let view = UIView()
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)

        view.centerXAnchor.constraint(equalTo: label.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true

        label.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 21).isActive = true
        view.trailingAnchor.constraint(greaterThanOrEqualTo: label.trailingAnchor, constant: 21).isActive = true

        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .center
        label.text = text

        return view
    }
}
