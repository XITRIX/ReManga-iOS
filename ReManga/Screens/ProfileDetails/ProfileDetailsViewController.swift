//
//  ProfileDetailsViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 06.05.2023.
//

import UIKit
import MvvmFoundation

class ProfileDetailsViewController<VM: ProfileDetailsViewModel>: MvvmViewController<VM> {
    @IBOutlet private var collectionView: UICollectionView!
    private lazy var dataSource = MvvmCollectionViewDataSource(collectionView: collectionView)

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.collectionViewLayout = MvvmCollectionViewLayout(dataSource)

        bind(in: disposeBag) {
            dataSource.applyModels <- viewModel.items
            viewModel.itemSelected <- dataSource.modelSelected
        }
    }
}
