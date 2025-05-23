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
        case mangadex

        var key: ContainerKey {
            switch self {
            case .remanga: return .init(key: "remanga", isDefault: true)
            case .newmanga: return .init(key: "newmanga")
            case .mangadex: return .init(key: "mangadex")
            }
        }

        var title: String {
            switch self {
            case .remanga: return "Re:Manga"
            case .newmanga: return "NewManga"
            case .mangadex: return "MangaDex"
            }
        }

        func resolve() -> ApiProtocol {
            Mvvm.shared.container.resolve(key: self.key)
        }
    }
}

class SceneDelegate: MvvmSceneDelegate {
    override func initialSetup() {
        UIView.enableUIColorsToLayer()
    }

    override func register(in container: Container) {
        container.registerSingleton(type: ApiProtocol.self, key: .Backend.newmanga.key, factory: NewMangaApi.init)
        container.registerSingleton(type: ApiProtocol.self, key: .Backend.remanga.key, factory: ReMangaApi.init)
        container.registerSingleton(type: ApiProtocol.self, key: .Backend.mangadex.key, factory: MangaDexApi.init)
        container.registerSingleton(factory: MangaDownloadManager.init)
        container.registerSingleton(factory: MangaHistoryManager.init)
    }

    override func routing(in router: Router) {
        // Overlays
        router.register(LoadingViewController<LoadingViewModel>.self)
        router.register(ErrorViewController<ErrorViewModel>.self)
        router.register(MangaPaymentViewController<MangaPaymentViewModel>.self)

        // Screens
        router.register(MvvmTabBarController<MainTabBarViewModel>.self)
        router.register(OverviewViewController<OverviewViewModel>.self)
        router.register(CatalogViewController<CatalogViewModel>.self)
        router.register(CatalogFiltersViewController<CatalogFiltersViewModel>.self)
        router.register(HistoryViewController<HistoryViewModel>.self)
        router.register(MangaDetailsViewController<MangaDetailsViewModel>.self)
        router.register(MangaReaderViewController<MangaReaderViewModel>.self)
        router.register(MangaReaderViewController<OfflineMangaReaderViewModel>.self)
        router.register(MangaReaderCommentsViewController<MangaReaderCommentsViewModel>.self)
        router.register(ProfileViewController<ProfileViewModel>.self)
        router.register(ProfileDetailsViewController<ProfileDetailsViewModel>.self)
        router.register(DownloadsViewController<DownloadsViewModel>.self)
        router.register(DownloadDetailsViewController<DownloadDetailsViewModel>.self)
        router.register(BookmarksViewController<BookmarksViewModel>.self)

        router.register(NewMangaAuthViewController<NewMangaAuthViewModel>.self)
        router.register(ReMangaAuthViewController<ReMangaVKAuthViewModel>.self)
        router.register(ReMangaAuthViewController<ReMangaGoogleAuthViewModel>.self)

        // Cells
        router.register(MangaCell<MangaCellViewModel>.self)
        router.register(CatalogFilterItemCell<CatalogFilterItemViewModel>.self)
        router.register(CatalogFilterHeaderCell<CatalogFilterHeaderViewModel>.self)
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
        router.register(MangaDetailsMakeCommentCell<MangaDetailsMakeCommentViewModel>.self)
        router.register(MangaDetailsCommentCell<MangaDetailsCommentViewModel>.self)
        router.register(MangaReaderPageCell<MangaReaderPageViewModel>.self)
        router.register(MangaReaderLoadNextCell<MangaReaderLoadNextViewModel>.self)
        router.register(MangaDetailsInsetCell<MangaDetailsInsetViewModel>.self)
        router.register(MangaDetailsTitleSimilarsCell<MangaDetailsTitleSimilarsViewModel>.self)

        // Profile cells
        router.register(ProfileAccountCell<ProfileAccountViewModel>.self)
        router.register(ProfileUserAccountCell<ProfileUserAccountViewModel>.self)
        router.register(ProfileActiveBackendCell<ProfileActiveBackendViewModel>.self)
        router.register(ProfileBookmarksCell<ProfileBookmarksViewModel>.self)
        router.register(ProfileColorPickerCell<ProfileColorPickerViewModel>.self)

        // Profile details cells
        router.register(ProfileDetailsButtonCell<ProfileDetailsButtonViewModel>.self)

        // Bookmarks cells
        router.register(BookmarksFilterHeaderCell<BookmarksFilterHeaderViewModel>.self)

        // Downloads cells
        router.register(ListViewMangaCell<DownloadsMangaViewModel>.self)
        router.register(DownloadDetailsChapterCell<DownloadDetailsChapterViewModel>.self)

        // History cells
        router.register(ListViewMangaCell<HistoryMangaItemViewModel>.self)

        // Widget cells
        router.register(WidgetHCollectionCell<WidgetHCollectionViewModel>.self)
    }

    override func resolveRootVC() -> UIViewController {
//        let main = CatalogViewModel.resolveVC()
//        return UINavigationController(rootViewController: main)

        return MainTabBarViewModel.resolveVC()
    }

    override func binding() {
        bind(in: disposeBag) {
            window!.rx.tintColor <- Properties.shared.$tintColor
        }
    }
}
