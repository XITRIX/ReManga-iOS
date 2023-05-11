//
//  MangaReaderPageCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 15.04.2023.
//

import Kingfisher
import MvvmFoundation
import UIKit

class MangaReaderPageCell<VM: MangaReaderPageViewModel>: MvvmCollectionViewCell<VM> {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var activityView: UIActivityIndicatorView!
    private var aspectRatioConstraint: NSLayoutConstraint!
    private var startZoomImageFrame: CGRect = .zero

    override func initSetup() {
        imageView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(zoomAction(_:))))
    }

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            imageView.rx.imageUrl(with: activityView, auth: viewModel.api?.kfAuthModifier) <- viewModel.imageUrl
            viewModel.imageSize.bind { [unowned self] size in
                if aspectRatioConstraint != nil {
                    aspectRatioConstraint.isActive = false
                }

                aspectRatioConstraint = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: size.height / size.width)
                aspectRatioConstraint.isActive = true
                invalidateIntrinsicContentSize()
            }
        }
    }

    @objc private func zoomAction(_ recognizer: UIPinchGestureRecognizer) {
        let scale = recognizer.scale
        let translation = recognizer.location(in: self)

        switch recognizer.state {
        case .possible:
            break
        case .began:
            startZoomImageFrame = imageView.frame
            imageView.anchorPoint = .init(x: translation.x / imageView.frame.width, y: translation.y / imageView.frame.height)
            fallthrough
        case .changed:
            guard recognizer.numberOfTouches > 1
            else {
                recognizer.state = .ended
                break
            }
            imageView.center = translation + CGPoint(x: startZoomImageFrame.minX * scale, y: 0)
            imageView.transform = CGAffineTransform(scaleX: scale, y: scale) // .translatedBy(x: translation.x - startZoomPoint.x, y: translation.y - startZoomPoint.y)
        default:
            UIView.animate(withDuration: 0.3) { [self] in
                imageView.center = startZoomImageFrame.center
                imageView.anchorPoint = .init(x: 0.5, y: 0.5)
                imageView.transform = .identity
            }
        }
    }

//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        guard let imageSize else { return }
//        widthConstraint.constant = frame.height / imageSize.height * imageSize.width
//    }
}
