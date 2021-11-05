//
//  UIImageViewExtensions.swift
//  ReManga
//
//  Created by Даниил Виноградов on 04.11.2021.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(_ link: String?) {
        if let link = link {
            kf.setImage(with: URL(string: link))
        } else {
            image = nil
        }
    }
}
