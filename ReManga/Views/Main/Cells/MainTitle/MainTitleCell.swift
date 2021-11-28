//
//  MainTitleCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 23.11.2021.
//

import UIKit

class MainTitleCell: UITableViewCell {
    @IBOutlet private var titleImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!

    func configure(for model: ReCatalogContent) {
        titleLabel.text = model.rusName ?? model.enName
        subtitleLabel.text = "\(model.type.text) \(model.issueYear.text)"
        titleImageView.kf.setImage(with: URL(string: ReClient.baseUrl + (model.img?.mid).text))
        dateLabel.isHidden = true
    }

    func configure(for model: ReUploadedChapterContent) {
        let additional = (model.countChapters ?? 0) > 0 ? " + ещё \(model.countChapters.text) главы" : ""

        titleLabel.text = model.rusName ?? model.enName
        subtitleLabel.text = "Том \(model.tome.text). Глава \(model.chapter.text).\(additional)"
        titleImageView.kf.setImage(with: URL(string: ReClient.baseUrl + (model.img?.mid).text))
        dateLabel.isHidden = false

        let interval = model.uploadDate / -1000
        dateLabel.text = Date().addingTimeInterval(interval).timeAgo()
    }
}
