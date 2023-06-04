//
//  UIImage+Extensions.swift
//  ReManga
//
//  Created by Даниил Виноградов on 04.06.2023.
//

import UIKit

extension UIImage {
    func with(size: CGSize) -> UIImage {
        let image = UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }

        return image.withRenderingMode(renderingMode)
    }
}
