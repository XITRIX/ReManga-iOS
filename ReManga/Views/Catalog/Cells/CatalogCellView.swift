//
//  CatalogCellView.swift
//  REManga
//
//  Created by Daniil Vinogradov on 08.03.2021.
//

import UIKit
import Kingfisher

class CatalogCellView: UICollectionViewCell {
    @IBOutlet var title: UILabel!
    @IBOutlet var subTitle: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var score: UILabel!
    @IBOutlet var status: UILabel!

    func setModel(_ model: ReCatalogContent) {
        title.text = model.rusName
        subTitle.text = "\((model.type ?? "")) \((model.genres?.first?.name ?? ""))"
        score.text = model.avgRating
        status.text = model.bookmarkType?.rawValue
        status.superview?.superview?.isHidden = model.bookmarkType == nil
        imageView.kf.setImage(with: URL(string: ReClient.baseUrl + (model.img?.mid ?? "")))
    }

    func setModel(_ model: ReSearchContent) {
        title.text = model.rusName
        subTitle.text = model.enName
        score.text = model.avgRating
        status.text = model.bookmarkType
        status.superview?.isHidden = model.bookmarkType == nil
        imageView.kf.setImage(with: URL(string: ReClient.baseUrl + (model.img?.mid ?? "")))
    }
}
