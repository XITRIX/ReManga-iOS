//
//  TitleCommentCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 08.11.2021.
//

import UIKit

class TitleCommentCell: BaseTableViewCell {
    @IBOutlet var userAvatar: UIImageView!
    @IBOutlet var username: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dislikeButton: UIButton!
    @IBOutlet var likesLabel: UILabel!
    @IBOutlet var replyButton: UIButton!
    @IBOutlet var showRepliesButton: UIButton!
    @IBOutlet var coloredView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setImageInset()
        textView.textContainer.lineFragmentPadding = 0
    }

    func setModel(_ model: ReCommentsContent) {
        if let link = model.user?.avatar?.low,
           let url = URL(string: ReClient.baseUrl + link) {
            userAvatar.kf.setImage(with: url)
        }

        username.text = model.user?.username
        textView.attributedText = model.text?.htmlAttributedString(size: 16)
        likesLabel.text = "\(model.score)"
        showRepliesButton.setTitle("Показать \(model.countReplies ?? 0) ответов", for: .normal)
        showRepliesButton.isHidden = model.countReplies ?? 0 == 0

        let interval = model.date / -1000
        date.text = Date().addingTimeInterval(interval).timeAgo()

        coloredView.backgroundColor = getRankColor(model.rank)
    }

    func setImageInset() {
        let img = userAvatar.superview!.convert(userAvatar.frame, to: textView)
        var intersectionFrame = textView.bounds.intersection(img)
        intersectionFrame.size.width += 8
        intersectionFrame.size.height -= 4
        let imageFrame = UIBezierPath(rect: intersectionFrame)
        textView.textContainer.exclusionPaths = [imageFrame]
    }

    func getRankColor(_ rank: ReCommentsRank?) -> UIColor {
        switch rank {
        case .ruby:
            return .systemPink
        case .gold:
            return .systemYellow
        case .silver:
            return .lightGray
        case .diamond:
            return .systemTeal
        case .bronze:
            return .systemOrange
        case .transparent, .none:
            return .tertiarySystemBackground
        }
    }
}
