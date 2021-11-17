//
//  UserViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 08.11.2021.
//

import UIKit

class UserViewController: BaseViewController<UserViewModel> {
    @IBOutlet var headerView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var balanceLabel: UILabel!
    @IBOutlet var countViewsLabel: UILabel!
    @IBOutlet var countVotesLabel: UILabel!
    @IBOutlet var countCommentsLabel: UILabel!

    override func setupView() {
        super.setupView()

        tableView.tableHeaderView = headerView
    }

    override func binding() {
        super.binding()

        viewModel.avatar.observeNext(with: avatarImage.setImage).dispose(in: bag)
        viewModel.username.bind(to: nicknameLabel).dispose(in: bag)
        viewModel.userId.bind(to: idLabel).dispose(in: bag)
        viewModel.balance.bind(to: balanceLabel).dispose(in: bag)
        viewModel.countViews.bind(to: countViewsLabel).dispose(in: bag)
        viewModel.countVotes.bind(to: countVotesLabel).dispose(in: bag)
        viewModel.countComments.bind(to: countCommentsLabel).dispose(in: bag)
    }
}
