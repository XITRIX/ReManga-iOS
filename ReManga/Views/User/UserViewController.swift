//
//  UserViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 08.11.2021.
//

import UIKit
import MVVMFoundation

class UserViewController: BaseViewController<UserViewModel> {
    @IBOutlet var headerView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var settingsButton: UIButton!
    @IBOutlet var balanceLabel: UILabel!
    @IBOutlet var ticketsLabel: UILabel!
    @IBOutlet var countViewsLabel: UILabel!
    @IBOutlet var countVotesLabel: UILabel!
    @IBOutlet var countCommentsLabel: UILabel!
    @IBOutlet var segmentControlView: LongSegmentView!

    override func setupView() {
        super.setupView()
        tableView.tableHeaderView = headerView
    }

    override func binding() {
        super.binding()

        bind(in: bag) {
            viewModel.avatar.bind(to: avatarImage.reactive.imageUrl)
            viewModel.username.bind(to: nicknameLabel)
            viewModel.userId.bind(to: idLabel)
            viewModel.balance.bind(to: balanceLabel)
            viewModel.tickets.bind(to: ticketsLabel)
            viewModel.countViews.bind(to: countViewsLabel)
            viewModel.countVotes.bind(to: countVotesLabel)
            viewModel.countComments.bind(to: countCommentsLabel)
        }
    }

    override func themeChanged() {
        settingsButton.layer.borderColor = UIColor.accentColor.cgColor
    }
}
