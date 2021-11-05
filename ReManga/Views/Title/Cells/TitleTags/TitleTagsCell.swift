//
//  TitleTagsCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 05.11.2021.
//

import UIKit
import TTGTags

class TitleTagsCell: BaseTableViewCell {
    @IBOutlet var tagsView: TTGTextTagCollectionView!

    var tagSelected: ((Int)->())?

    override func prepareForReuse() {
        tagsView.removeAllTags()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        tagsView.delegate = self
    }
}

extension TitleTagsCell: TTGTextTagCollectionViewDelegate {
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, canTap tag: TTGTextTag!, at index: UInt) -> Bool {
        true
    }

    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTap tag: TTGTextTag!, at index: UInt) {
        tagSelected?(Int(index))
    }
}
