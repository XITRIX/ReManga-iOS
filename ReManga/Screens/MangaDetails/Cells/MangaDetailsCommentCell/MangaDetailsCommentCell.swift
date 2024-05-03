//
//  MangaDetailsCommentCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 16.04.2023.
//

import UIKit
import MvvmFoundation
import RxSwift
import RxCocoa

class MangaDetailsCommentCell<VM: MangaDetailsCommentViewModel>: MvvmCollectionViewCell<VM> {
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var scoreLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var messageContainer: UIView!
    @IBOutlet private var repliesButton: UIButton!
    @IBOutlet private var leftOffsetConstraint: NSLayoutConstraint!
    @IBOutlet private var hierarchyStack: UIStackView!
    @IBOutlet private var pinImageView: UIImageView!
    @IBOutlet private var activityView: UIActivityIndicatorView!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var dislikeButton: UIButton!
    @IBOutlet private var repliesActivityView: UIActivityIndicatorView!

    override func initSetup() {
        imageView.layer.cornerRadius = 12
        imageView.layer.cornerCurve = .continuous

        messageContainer.layer.cornerRadius = 16
        messageContainer.layer.cornerCurve = .continuous
        messageContainer.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            nameLabel.rx.text <- viewModel.name
            dateLabel.rx.text <- viewModel.date
            scoreLabel.rx.text <- viewModel.score.map(String.init)
            imageView.rx.imageUrl(with: activityView, placeholder: UIImage(resource: .noUserAvatar)) <- viewModel.image

            viewModel.toggleLike <- likeButton.rx.tap
            viewModel.toggleDislike <- dislikeButton.rx.tap

            viewModel.repliesLoading.bind { [unowned self] loading in
                setRepliesLoading(loading)
            }

            viewModel.isLiked.bind { [unowned self] liked in
                likeButton.configuration = liked == true ? likeButton.configuration?.toFilled() : likeButton.configuration?.toTinted()
                dislikeButton.configuration = liked == false ? dislikeButton.configuration?.toFilled() : dislikeButton.configuration?.toTinted()
            }

            Observable.combineLatest(viewModel.score, viewModel.isPinned).bind { [unowned self] (score, pinned) in
                applyScore(score, pinned)
            }
            viewModel.moreButtonText.bind { [unowned self] text in
                repliesButton.setTitle(text, for: .normal)
                repliesButton.superview?.isHidden = text.isNilOrEmpty
            }
            viewModel.content.bind { [unowned self] text in
                textLabel.attributedText = text
                invalidateIntrinsicContentSize()
            }
            viewModel.hierarchy.bind { [unowned self] hierarchy in
                setupHierarchy(hierarchy)
            }
            viewModel.isExpanded.bind { [unowned self] expanded in
                var config: UIButton.Configuration = expanded ? .filled() : .tinted()
                config.buttonSize = .mini
                repliesButton.configuration = config
                repliesButton.setTitle(viewModel.moreButtonText.value, for: .normal)
            }
        }
    }

    @IBAction func repliesAction(_ sender: UIButton) {
        viewModel.toggleReplies()
    }
}

private extension MangaDetailsCommentCell {
    func setRepliesLoading(_ loading: Bool) {
        if loading {
            guard let title = repliesButton.configuration?.title
            else { return }
            repliesButton.configuration?.attributedTitle = AttributedString(title, attributes: AttributeContainer([NSAttributedString.Key.foregroundColor : UIColor.clear]))
        }

        repliesActivityView.setAnimation(loading)
    }

    func applyScore(_ score: Int, _ pinned: Bool) {
        pinImageView.isHidden = !pinned

        if pinned {
            messageContainer.layer.borderWidth = 1
            messageContainer.borderColor = UIColor.tintColor
            return
        }

        if score >= 10 {
            messageContainer.layer.borderWidth = 1
            messageContainer.borderColor = UIColor(red: 205/255, green: 127/255, blue: 50/255, alpha: 1)
        } else if score >= 25 {
            messageContainer.layer.borderWidth = 1
            messageContainer.borderColor = UIColor(red: 217/255, green: 170/255, blue:6/255, alpha: 1)
        } else {
            messageContainer.layer.borderWidth = 0
            messageContainer.borderColor = nil
        }
    }

    func setupHierarchy(_ hierarchy: Int) {
        hierarchyStack.isHidden = hierarchy == 0
        hierarchyStack.subviews.forEach { $0.removeFromSuperview() }
        for _ in 0 ..< hierarchy {
            hierarchyStack.addArrangedSubview(makeOffsetView())
        }
    }

    func makeOffsetView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 8).isActive = true

        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .gray

        view.addSubview(line)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: line.leadingAnchor),
            view.topAnchor.constraint(equalTo: line.topAnchor),
            line.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            line.widthAnchor.constraint(equalToConstant: 2)
        ])

        return view
    }
}
