//
//  MainTItlesCollectionCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 22.11.2021.
//

import UIKit

protocol MainTitlesCollectionCellProtocol: AnyObject {
    func similarSelected(at index: Int)
}

class MainTitlesCollectionCell: BaseTableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!

    weak var delegate: MainTitlesCollectionCellProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(cell: TitleSimilarCollectionCell.self)
    }

    func setTitle(_ title: String?) {
        titleLabel.text = title
        titleLabel.superview?.isHidden = title?.isEmpty ?? true
    }
}
