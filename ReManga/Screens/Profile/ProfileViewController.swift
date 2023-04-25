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

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()

        bind(in: disposeBag) {
            viewModel.items.bind { [unowned self] items in
                dataSource.applyModels(items)
            }
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func setupCollectionView() {
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = MvvmCollectionViewLayout(dataSource)
    }
}
