//
//  BranchChapterCell.swift
//  REManga
//
//  Created by Daniil Vinogradov on 05.11.2021.
//

import UIKit

class TitleChapterCell: UITableViewCell {
    @IBOutlet var tome: UILabel!
    @IBOutlet var chapter: UILabel!
    @IBOutlet var pubDate: UILabel!
    @IBOutlet var publishers: UILabel!
    @IBOutlet var score: UILabel!
    @IBOutlet var like: UIImageView!

    func setModel(_ model: ReBranchContent) {
        tome.text = model.tome.text
        chapter.text = "Глава \(model.chapter.text)"
        like.image = UIImage(systemName: (model.rated ?? false) ? "heart.fill" : "heart")
        publishers.text = model.publishers?.compactMap {
            $0.name
        }.joined(separator: " ")
        score.text = model.score?.cropText()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        if let sDate = model.uploadDate,
           let date = dateFormatter.date(from: sDate)
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            let text = formatter.string(from: date)
            pubDate.text = text
        }

        let textColor = (model.viewed ?? false) ? UIColor.secondaryLabel : UIColor.label
        tome.textColor = textColor
        chapter.textColor = textColor
        pubDate.textColor = textColor
        publishers.textColor = textColor
    }
}
