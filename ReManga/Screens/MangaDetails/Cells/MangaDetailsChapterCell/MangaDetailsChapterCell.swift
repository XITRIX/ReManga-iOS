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

    override func initSetup() {
        accessories = [.disclosureIndicator(displayed: .whenNotEditing), .multiselect(displayed: .whenEditing)]
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
            viewModel.unlocked.bind { [unowned self] unlocked in
                lockImageView.isHidden = unlocked == nil
                guard let unlocked else { return }
                lockImageView.image = unlocked ? .init(systemName: "lock.open.fill")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal) : .init(systemName: "lock.fill")
            }
        }
    }
}
