//
//  UIImageView+Extensions.swift
//  ReManga
//
//  Created by Даниил Виноградов on 12.04.2023.
//

import UIKit
import Kingfisher
import RxSwift

extension UIImageView {

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

extension Reactive where Base: UIImageView {
    public func imageUrl(with activityIndicator: UIActivityIndicatorView? = nil, auth modifier: AnyModifier? = nil, placeholder: UIImage? = nil, completion: ((UIImage?) -> Void)? = nil) -> Binder<String?> {
        Binder(self.base) { imageView, image in
            guard let image else { return imageView.image = placeholder }
            activityIndicator?.startAnimating()

            var options: KingfisherOptionsInfo = []
            if let modifier {
                options.append(.requestModifier(modifier))
            }
            
            imageView.kf.setImage(with: URL(string: image), options: options) { result in
                activityIndicator?.stopAnimating()
                switch result {
                case .failure(_):
                    imageView.image = placeholder
                    completion?(nil)
                case .success(let image):
                    completion?(image.image)
                    break
                }
            }
        }
    }
}
