//
//  BaseTableViewCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 05.11.2021.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        bag.dispose()
    }
}
