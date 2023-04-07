//
//  MainTabBarViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 12.04.2023.
//

import MvvmFoundation

class MainTabBarViewModel: MvvmTabBarViewModel {
    required init() {
        super.init()
        tabs.accept([
            .init(viewModel: CatalogViewModel(), image: .init(systemName: "rectangle.grid.3x2")!, selectedImage: .init(systemName: "rectangle.grid.3x2.fill"))
        ])
    }
}
