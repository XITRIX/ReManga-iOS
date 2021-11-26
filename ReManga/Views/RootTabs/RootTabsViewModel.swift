//
//  RootTabsViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 06.11.2021.
//

import UIKit

class RootTabsViewModel: MvvmTabsViewModel {
    required init() {
        super.init()

        setModels([MvvmTabItem(item: MainViewModel.self,
                               title: "Главная",
                               image: UIImage(systemName: "square.grid.3x1.below.line.grid.1x2"),
                               selectedImage: UIImage(systemName: "square.grid.3x1.fill.below.line.grid.1x2")),
                   MvvmTabItem(item: CatalogViewModel.self,
                               title: "Каталог",
                               image: UIImage(systemName: "rectangle.grid.3x2"),
                               selectedImage: UIImage(systemName: "rectangle.grid.3x2.fill")),
                   MvvmTabItem(item: UserViewModel.self,
                               title: "Профиль",
                               image: UIImage(systemName: "person"),
                               selectedImage: UIImage(systemName: "person.fill"))])
    }
}
