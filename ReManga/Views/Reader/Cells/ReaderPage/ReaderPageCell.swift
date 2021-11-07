//
//  ReaderPageCell.swift
//  REManga
//
//  Created by Даниил Виноградов on 10.04.2021.
//

import UIKit

class ReaderPageCell: BaseTableViewCell {
    @IBOutlet var pageImage: UIImageView!
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var scrollView: UIScrollView!

    let maxScalingFactor: CGFloat = 5
    let gestureScalingFactor: CGFloat = 3
    let tapsRequiredForZoom = 2

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        reloadImageScales()
        centerImage()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        loader.isHidden = false
        loader.startAnimating()
    }

    func setModel(_ model: ReChapterPage) {
        reloadImageScales()
        pageImage.kf.setImage(with: URL(string: model.link ?? "")) { [weak self] result in
            guard let self = self else { return }

            self.loader.isHidden = true
            self.loader.stopAnimating()
        }
    }
}

// MARK: - Setup
private extension ReaderPageCell {
    func setup() {
//        setupGestures()
        setupScrollView()
    }

    func setupScrollView() {
        scrollView.delegate = self
        scrollView.decelerationRate = .fast
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }

    func setupGestures() {
//        let zoomingGesture = UITapGestureRecognizer(target: self, action: #selector(didTapZoomingGesture))
//        zoomingGesture.numberOfTapsRequired = tapsRequiredForZoom
//        scrollView.addGestureRecognizer(zoomingGesture)
    }
}

// MARK: - Private functions
private extension ReaderPageCell {
    func reloadImageScales() {
        scrollView.contentSize = frame.size
        pageImage.frame.size = frame.size
        
        setCurrentMinAndMaxZoomScale()
        scrollView.zoomScale = 1
    }

    func setCurrentMinAndMaxZoomScale() {
        let boundsSize = bounds.size
        let imageSize = pageImage.bounds.size

//        let xScale = boundsSize.width.rounded(.up) / imageSize.width.rounded(.up)
        let yScale = boundsSize.height / imageSize.height
//        let minScale = max(xScale, yScale)
        let minScale = yScale

        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = maxScalingFactor
    }

    func centerImage() {
        let boundsSize = bounds.size
        var frameToCenter = pageImage.frame

        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }

        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }

        pageImage.frame = frameToCenter
    }

//    @objc func didTapZoomingGesture(sender: UITapGestureRecognizer) {
//        if scrollView.zoomScale > scrollView.minimumZoomScale {
//            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
//            return
//        }
//
//        let location = sender.location(in: pageImage)
//        let scaleFactor = scrollView.minimumZoomScale * gestureScalingFactor
//        let zoomRect = getZoomingRect(in: location, scale: scaleFactor)
//        scrollView.zoom(to: zoomRect, animated: true)
//    }
//
//    func getZoomingRect(in location: CGPoint, scale: CGFloat) -> CGRect {
//        var zoomRect: CGRect = .zero
//
//        zoomRect.size.width = bounds.size.width / scale
//        zoomRect.size.height = bounds.size.height / scale
//
//        zoomRect.origin.x = location.x - (zoomRect.size.width / 2)
//        zoomRect.origin.y = location.y - (zoomRect.size.height / 2)
//
//        return zoomRect
//    }
}

// MARK: - UIScrollViewDelegate
extension ReaderPageCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        pageImage
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
}
