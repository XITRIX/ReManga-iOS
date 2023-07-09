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
//            .init(viewModel: OverviewViewModel(), image: .init(systemName: "square.grid.3x1.below.line.grid.1x2")!, selectedImage: .init(systemName: "square.grid.3x1.below.line.grid.1x2.fill")),
            .init(viewModel: CatalogViewModel(with: .default), image: .init(systemName: "rectangle.grid.3x2")!, selectedImage: .init(systemName: "rectangle.grid.3x2.fill")),
            .init(viewModel: HistoryViewModel(), image: .init(systemName: "clock")!, selectedImage: .init(systemName: "clock.fill")),
            .init(viewModel: DownloadsViewModel(), image: .init(systemName: "square.and.arrow.down")!, selectedImage: .init(systemName: "square.and.arrow.down.fill")),
            .init(viewModel: ProfileViewModel(), image: .init(systemName: "person")!, selectedImage: .init(systemName: "person.fill"))
        ])
    }
}
