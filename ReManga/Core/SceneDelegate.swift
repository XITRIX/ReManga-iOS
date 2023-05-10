//
//  SceneDelegate.swift
//  ReManga
//
//  Created by Даниил Виноградов on 07.04.2023.
//

import MvvmFoundation
import UIKit

public extension ContainerKey {
    enum Backend: Codable {
        case remanga
        case newmanga

        var key: ContainerKey {
            switch self {
            case .remanga: return .init(key: "remanga", isDefault: true)
            case .newmanga: return .init(key: "newmanga")
            }
        }

        var title: String {
            switch self {
            case .remanga: return "Re:Manga"
            case .newmanga: return "NewManga"
            }
        }
    }
}

class SceneDelegate: MvvmSceneDelegate {
    override func register(in container: Container) {
        container.registerSingleton(type: ApiProtocol.self, key: .Backend.newmanga.key, factory: NewMangaApi.init)
        container.registerSingleton(type: ApiProtocol.self, key: .Backend.remanga.key, factory: ReMangaApi.init)
        container.registerSingleton(factory: MangaDownloadManager.init)
    }

    override func routing(in router: Router) {
        // Overlays
        router.register(LoadingViewController<LoadingViewModel>.self)
        router.register(ErrorViewController<ErrorViewModel>.self)
        router.register(MangaPaymentViewController<MangaPaymentViewModel>.self)

        // Screens
        router.register(MvvmTabBarController<MainTabBarViewModel>.self)
        router.register(CatalogViewController<CatalogViewModel>.self)
        router.register(MangaDetailsViewController<MangaDetailsViewModel>.self)
        router.register(MangaReaderViewController<MangaReaderViewModel>.self)
        router.register(MangaReaderViewController<OfflineMangaReaderViewModel>.self)
        router.register(ProfileViewController<ProfileViewModel>.self)
        router.register(ProfileDetailsViewController<ProfileDetailsViewModel>.self)
        router.register(DownloadsViewController<DownloadsViewModel>.self)
        router.register(DownloadDetailsViewController<DownloadDetailsViewModel>.self)

        router.register(NewMangaAuthViewController<NewMangaAuthViewModel>.self)
        router.register(ReMangaAuthViewController<ReMangaAuthViewModel>.self)

        // Cells
        router.register(MangaCell<MangaCellViewModel>.self)
        router.register(DetailsHeaderCap<DetailsHeaderCapViewModel>.self)
        router.register(MangaDetailsDescriptionTextCell<MangaDetailsDescriptionTextViewModel>.self)
        router.register(MangaDetailsSelectorCell<MangaDetailsSelectorViewModel>.self)
        router.register(MangaDetailsTagsCell<MangaDetailsTagsViewModel>.self)
        router.register(MangaDetailsTagCell<MangaDetailsTagViewModel>.self)
        router.register(MangaDetailsChapterCell<MangaDetailsChapterViewModel>.self)
        router.register(MangaDetailsChaptersMenuCell<MangaDetailsChaptersMenuViewModel>.self)
        router.register(MangaDetailsTranslatorCell<MangaDetailsTranslatorViewModel>.self)
        router.register(MangaDetailsHeaderCell<MangaDetailsHeaderViewModel>.self)
        router.register(MangaDetailsLoadingPlaceholderCell<MangaDetailsLoadingPlaceholderViewModel>.self)
        router.register(MangaDetailsCommentCell<MangaDetailsCommentViewModel>.self)
        router.register(MangaReaderPageCell<MangaReaderPageViewModel>.self)
        router.register(MangaReaderLoadNextCell<MangaReaderLoadNextViewModel>.self)
        router.register(MangaDetailsInsetCell<MangaDetailsInsetViewModel>.self)

        // Profile cells
        router.register(ProfileAccountCell<ProfileAccountViewModel>.self)
        router.register(ProfileUserAccountCell<ProfileUserAccountViewModel>.self)
        router.register(ProfileActiveBackendCell<ProfileActiveBackendViewModel>.self)

        // Profile details cells
        router.register(ProfileDetailsButtonCell<ProfileDetailsButtonViewModel>.self)

        // Downloads cells
        router.register(DownloadsMangaCell<DownloadsMangaViewModel>.self)
        router.register(DownloadDetailsChapterCell<DownloadDetailsChapterViewModel>.self)
    }

    override func resolveRootVC() -> UIViewController {
//        let main = CatalogViewModel.resolveVC()
//        return UINavigationController(rootViewController: main)

        return MainTabBarViewModel.resolveVC()
    }
}
