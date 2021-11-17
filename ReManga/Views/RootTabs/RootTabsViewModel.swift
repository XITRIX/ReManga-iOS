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

        setModels([MvvmTabItem(item: CatalogViewModel.self,
                               title: "Каталог",
                               image: UIImage(systemName: "rectangle.grid.3x2"),
                               selectedImage: UIImage(systemName: "rectangle.grid.3x2.fill")),
                   MvvmTabItem(item: UserViewModel.self,
                               title: "Профиль",
                               image: UIImage(systemName: "person"),
                               selectedImage: UIImage(systemName: "person.fill"))])
    }
}
