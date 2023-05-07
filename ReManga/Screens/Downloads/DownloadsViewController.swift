//
//  DownloadsViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 07.05.2023.
//

import UIKit
import MvvmFoundation

class DownloadsViewController<VM: DownloadsViewModel>: BaseViewController<VM> {
    @IBOutlet private var collectionView: UICollectionView!
    private lazy var dataSource = MvvmCollectionViewDataSource(collectionView: collectionView)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        smoothlyDeselectItems(in: collectionView)
    }
}

private extension DownloadsViewController {
    func setupCollectionView() {
        collectionView.collectionViewLayout = MvvmCollectionViewLayout(dataSource)
        collectionView.dataSource = dataSource

        bind(in: disposeBag) {
            dataSource.applyModels <- viewModel.items
            viewModel.modelSelected <- dataSource.modelSelected
        }
    }
}
