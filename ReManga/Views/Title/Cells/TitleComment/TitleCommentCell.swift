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

    override func awakeFromNib() {
        super.awakeFromNib()
        setImageInset()
    }

    func setModel(_ model: ReCommentsContent) {
        if let link = model.user?.avatar?.low,
           let url = URL(string: ReClient.baseUrl + link) {
            userAvatar.kf.setImage(with: url)
        }

        username.text = model.user?.username
        textView.text = model.text
        likesLabel.text = "\(model.score)"
        showRepliesButton.setTitle("Показать \(model.countReplies ?? 0) ответов", for: .normal)
        showRepliesButton.isHidden = model.countReplies ?? 0 == 0
    }

    func setImageInset() {
        let img = userAvatar.superview!.convert(userAvatar.frame, to: textView)
        var intersectionFrame = textView.bounds.intersection(img)
        intersectionFrame.size.width += 8
        intersectionFrame.size.height -= 4
        let imageFrame = UIBezierPath(rect: intersectionFrame)
        textView.textContainer.exclusionPaths = [imageFrame]
    }
}
