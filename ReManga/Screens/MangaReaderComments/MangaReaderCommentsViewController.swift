//
//  MangaReaderComments.swift
//  ReManga
//
//  Created by Даниил Виноградов on 04.06.2023.
//

import UIKit
import MvvmFoundation

class MangaReaderCommentsViewController<VM: MangaReaderCommentsViewModel>: MvvmViewController<VM> {
    @IBOutlet private var collectionView: UICollectionView!
    private lazy var dataSource = MvvmCollectionViewDataSource(collectionView: collectionView)
    private let dismissItem = UIBarButtonItem(systemItem: .close)

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.trailingItemGroups.append(.fixedGroup(items: [dismissItem]))

        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = MvvmCollectionViewLayout(dataSource)

        bind(in: disposeBag) {
            dataSource.applyModels <- viewModel.items
            viewModel.dismiss <- dismissItem.rx.tap
        }
    }

}
