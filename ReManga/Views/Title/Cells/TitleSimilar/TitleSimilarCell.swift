//
//  TitleSimilarCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 05.11.2021.
//

import UIKit

protocol TitleSimilarCellProtocol: AnyObject {
    func similarSelected(at index: Int)
}

class TitleSimilarCell: BaseTableViewCell {
    @IBOutlet var collectionView: UICollectionView!

    weak var delegate: TitleSimilarCellProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(cell: TitleSimilarCollectionCell.self)
    }
}
