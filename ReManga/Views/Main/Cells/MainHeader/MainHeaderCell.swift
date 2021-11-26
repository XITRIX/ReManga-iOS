//
//  MainHeaderCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 23.11.2021.
//

import UIKit

class MainHeaderCell: UITableViewCell {
    @IBOutlet private var titleLabel: UILabel!

    func configure(for title: String) {
        titleLabel.text = title
    }
}
