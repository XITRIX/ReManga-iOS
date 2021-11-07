//
//  CatalogFilterCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 06.11.2021.
//

import UIKit
import TTGTags

class CatalogFilterCell: BaseTableViewCell {
    @IBOutlet var tagsView: TTGTextTagCollectionView!
    @IBOutlet var titleHolder: UIView!
    @IBOutlet var tagsViewHolder: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var chevronImage: UIImageView!

    @IBOutlet var filtersCountLabel: UILabel!
    @IBOutlet var filtersCountHolder: UIView!

    private var tagsHidden: Bool = true
    var clicked: ((Bool)->())?
    var tagSelected: ((_ index: Int, _ selected: Bool)->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        tagsView.enableTagSelection = true
        tagsView.delegate = self
        tagsView.backgroundColor = tagsView.backgroundColor?.withAlphaComponent(0.9)
        tagsViewHolder.isHidden = tagsHidden
        titleHolder.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }

    func configure(_ hidden: Bool, animated: Bool) {
        tagsHidden = hidden
        if tagsViewHolder.isHidden != tagsHidden {
            tagsViewHolder.isHidden = tagsHidden
        }
        UIView.animate(withDuration: animated ? 0.3 : 0) {
            self.chevronImage.transform = CGAffineTransform(rotationAngle: hidden ? 0 : .pi/2)
        }
    }

    @objc func tapped() {
        tagsHidden = !tagsHidden
        clicked?(tagsHidden)
    }
}

extension CatalogFilterCell: TTGTextTagCollectionViewDelegate {
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, canTap tag: TTGTextTag!, at index: UInt) -> Bool {
        true
    }

    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTap tag: TTGTextTag!, at index: UInt) {
        tagSelected?(Int(index), tag.selected)
    }
}
