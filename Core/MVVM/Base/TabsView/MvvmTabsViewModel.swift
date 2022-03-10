//
//  MvvmTabsViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 06.11.2021.
//

import Foundation
import Bond

struct MvvmTabItem {
    let item: MvvmViewModel.Type
    let title: String?
    let image: UIImage?
    let selectedImage: UIImage?
}

protocol MvvmTabsViewModelProtocol: MvvmViewModelProtocol {
    var viewModels: MutableObservableCollection<[MvvmTabItem]> { get }

    func setModels(_ models: [MvvmTabItem])
}

class MvvmTabsViewModel: MvvmViewModel, MvvmTabsViewModelProtocol {
    let viewModels = MutableObservableCollection<[MvvmTabItem]>([])

    func setModels(_ models: [MvvmTabItem]) {
        viewModels.replace(with: models)
    }
}
