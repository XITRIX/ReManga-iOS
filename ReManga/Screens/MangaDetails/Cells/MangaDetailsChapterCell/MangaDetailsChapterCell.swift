//
//  MangaDetailsChapterCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 14.04.2023.
//

import UIKit
import RxSwift
import MvvmFoundation

class MangaDetailsChapterCell<VM: MangaDetailsChapterViewModel>: MvvmCollectionViewListCell<VM> {
    @IBOutlet private var tomeLabel: UILabel!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var teamLabel: UILabel!
    @IBOutlet private var lockImageView: UIImageView!
    @IBOutlet private var heartImageView: UIImageView!
    @IBOutlet private var downloadedImageView: UIImageView!
    @IBOutlet private var downloadProgressView: RoundedProgress!

    private var trailingSeparatorConstraint: NSLayoutConstraint!

    override func initSetup() {
        accessories = [.disclosureIndicator(displayed: .whenNotEditing), .multiselect(displayed: .whenEditing)]
        separatorLayoutGuide.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        trailingSeparatorConstraint = separatorLayoutGuide.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)

        backgroundConfiguration = defaultBackgroundConfiguration()
        backgroundConfiguration?.backgroundColorTransformer = .init { [unowned self] color in
            return configurationState.isSelected || configurationState.isHighlighted ? .separator : .clear
        }
    }

    override func setup(with viewModel: VM) {
        bind(in: disposeBag) {
            viewModel.chapter.bind(to: tomeLabel.rx.text)
            tomeLabel.rx.text <- viewModel.tome
            nameLabel.rx.text <- viewModel.chapter
            dateLabel.rx.textWithVisibility <- viewModel.date
            teamLabel.rx.textWithVisibility <- viewModel.team
            nameLabel.rx.textColor <- viewModel.isReaded.map { $0 ? .secondaryLabel : .label }
            heartImageView.rx.isHidden <- viewModel.isLiked.map { !$0 }
            downloadedImageView.rx.isHidden <- viewModel.loadingProgress.map { $0 ?? 0 < 1 }
            downloadProgressView.rx.isHidden <- viewModel.loadingProgress.map { $0 == nil || $0! >= 1 }
            downloadProgressView.rx.progress <- viewModel.loadingProgress.map { $0 ?? 0 }
            viewModel.unlocked.bind { [unowned self] unlocked in
                lockImageView.isHidden = unlocked == nil
                guard let unlocked else { return }
                lockImageView.image = unlocked ? .init(systemName: "lock.open.fill")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal) : .init(systemName: "lock.fill")
            }
            Observable.combineLatest(viewModel.loadingProgress, viewModel.unlocked).map { ($0 == nil, $1) }.bind { [unowned self] ableToDownload, unlocked in
                accessories = [.disclosureIndicator(displayed: .whenNotEditing)]
                if ableToDownload && unlocked != false { accessories.append(.multiselect(displayed: .whenEditing)) }
            }
        }
    }

    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        trailingSeparatorConstraint.isActive = layoutMargins.right > window?.rootViewController?.systemMinimumLayoutMargins.trailing ?? 0
    }
}
