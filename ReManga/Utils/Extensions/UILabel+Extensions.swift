//
//  UILabel+Extensions.swift
//  ReManga
//
//  Created by Даниил Виноградов on 16.04.2023.
//

import UIKit

extension UILabel {
    var isTruncated: Bool {
        guard let labelText = text,
              !labelText.isEmpty
        else { return false }

        let labelTextSize = (labelText as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font!],
            context: nil).size

        return labelTextSize.height > bounds.size.height
    }
}
