//
//  ProfileViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 18.04.2023.
//

import MvvmFoundation
import RxBiBinding
import UIKit

class ProfileViewController<VM: ProfileViewModel>: BaseViewController<VM> {
    @IBOutlet private var collectionView: UICollectionView!
    private lazy var dataSource = MvvmCollectionViewDataSource(collectionView: collectionView)
    private lazy var delegates = Delegates(parent: self)
    private let notificationButton: UIBarButtonItem = .init()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupNavigationItem()

        bind(in: disposeBag) {
            viewModel.modelSelected <- dataSource.modelSelected
            dataSource.applyModels <- viewModel.items
            dataSource.deselectItems <- viewModel.deselectItems
            notificationButton.rx.image <- viewModel.hasNewNotification.map { Self.getNotificationImage(withBadge: $0) }
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func setupCollectionView() {
        collectionView.dataSource = dataSource
        collectionView.delegate = delegates
        collectionView.collectionViewLayout = MvvmCollectionViewLayout(dataSource)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        smoothlyDeselectItems(in: collectionView)
    }
}

private extension ProfileViewController {
    class Delegates: DelegateObject<ProfileViewController>, UICollectionViewDelegate {
        func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
            parent.viewModel.items.value[indexPath.section].items[indexPath.item].canBeSelected
        }
    }
}

private extension ProfileViewController {
    static func getNotificationImage(withBadge: Bool) -> UIImage? {
        withBadge ?
            .init(systemName: "bell.badge")?.withConfiguration(UIImage.SymbolConfiguration(paletteColors: [.systemRed, .tintColor])) :
            .init(systemName: "bell")
    }

    func setupNavigationItem() {
//        navigationController?.tabBarItem.badgeValue = "2"
//        navigationItem.trailingItemGroups.append(.fixedGroup(items: [notificationButton]))
        notificationButton.primaryAction = .init { _ in
            print("")
        }
    }
}
