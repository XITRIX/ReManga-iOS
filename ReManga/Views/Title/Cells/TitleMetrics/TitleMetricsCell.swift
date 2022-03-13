//
//  TitleMetricsCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 05.11.2021.
//

import UIKit

class TitleMetricsCell: BaseTableViewCell {
    @IBOutlet private var rootView: UIView!

    @IBOutlet var likesLabel: UILabel!
    @IBOutlet var viewsLabel: UILabel!
    @IBOutlet var bookmarksLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        rootView.layer.cornerCurve = .continuous
    }
}
