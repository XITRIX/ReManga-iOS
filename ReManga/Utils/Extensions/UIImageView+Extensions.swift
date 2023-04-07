//
//  UIImageView+Extensions.swift
//  ReManga
//
//  Created by Даниил Виноградов on 12.04.2023.
//

import UIKit
import Kingfisher

extension UIImageView {
    var imageUrl: String? {
        get { "" }
        set {
            guard let newValue else { return image = nil }
            kf.setImage(with: URL(string: newValue))
        }
    }

    func setImage(_ url: String?, completion: (() -> Void)? = nil) {
        guard let url else {
            image = nil
            completion?()
            return
        }

        kf.setImage(with: URL(string: url)) { _ in
            completion?()
        }

    }
}
