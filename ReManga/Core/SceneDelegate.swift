//
//  SceneDelegate.swift
//  ReManga
//
//  Created by Даниил Виноградов on 07.04.2023.
//

import UIKit
import MvvmFoundation

class SceneDelegate: MvvmSceneDelegate {
    override func register(in container: Container) {
        container.registerSingleton(type: ApiProtocol.self, factory: NewMangaApi.init)
    }

    override func routing(in router: Router) {
        // Overlays
        router.register(LoadingViewController<LoadingViewModel>.self)
        router.register(ErrorViewController<ErrorViewModel>.self)

        // Screens
        router.register(MvvmTabBarController<MainTabBarViewModel>.self)
        router.register(CatalogViewController<CatalogViewModel>.self)
        router.register(MangaDetailsViewController<MangaDetailsViewModel>.self)
        router.register(MangaReaderViewController<MangaReaderViewModel>.self)

        // Cells
        router.register(MangaCell<MangaCellViewModel>.self)
        router.register(DetailsHeaderCap<DetailsHeaderCapViewModel>.self)
        router.register(MangaDetailsDescriptionTextCell<MangaDetailsDescriptionTextViewModel>.self)
        router.register(MangaDetailsSelectorCell<MangaDetailsSelectorViewModel>.self)
        router.register(MangaDetailsTagsCell<MangaDetailsTagsViewModel>.self)
        router.register(MangaDetailsTagCell<MangaDetailsTagViewModel>.self)
        router.register(MangaDetailsChapterCell<MangaDetailsChapterViewModel>.self)



    }

    override func resolveRootVC() -> UIViewController {
//        let main = CatalogViewModel.resolveVC()
//        return UINavigationController(rootViewController: main)

        return MainTabBarViewModel.resolveVC()
    }
}

