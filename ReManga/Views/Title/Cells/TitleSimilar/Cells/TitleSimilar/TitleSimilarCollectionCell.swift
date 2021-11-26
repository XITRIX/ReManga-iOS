//
//  TitleSimilarCollectionCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 05.11.2021.
//

import UIKit

class TitleSimilarCollectionCell: UICollectionViewCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var details: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet var totalFavorites: UILabel!

    func setModel(_ model: ReCatalogContent) {
        name.text = model.rusName
        details.text = model.type
        totalFavorites.text = model.totalVotes?.cropText()
        image.kf.setImage(with: URL(string: ReClient.baseUrl + (model.img?.mid).text))
    }
}
