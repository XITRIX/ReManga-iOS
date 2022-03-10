//
//  TitleLoadingCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 15.12.2021.
//

import UIKit

class TitleLoadingCell: UITableViewCell {
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
