//
//  OverviewViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 04.07.2023.
//

import UIKit
import MvvmFoundation

class OverviewViewController<VM: OverviewViewModel>: BaseViewController<VM> {
    @IBOutlet private var collectionView: UICollectionView!
    private lazy var dataSource = MvvmCollectionViewDataSource(collectionView: collectionView)
    private lazy var delegates = Delegates(parent: self)

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never

        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = MvvmCollectionViewLayout(dataSource)

        bind(in: disposeBag) {
            dataSource.applyModels <- viewModel.sections
        }
    }
}

private extension OverviewViewController {
    class Delegates: DelegateObject<OverviewViewController> {}
}
