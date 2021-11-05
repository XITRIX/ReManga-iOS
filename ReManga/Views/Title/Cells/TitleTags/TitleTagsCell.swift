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

    override func prepareForReuse() {
        tagsView.removeAllTags()
    }
}
