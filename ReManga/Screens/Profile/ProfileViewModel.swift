//
//  ProfileViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 18.04.2023.
//

import MvvmFoundation
import RxBiBinding
import RxRelay
import RxSwift

class ProfileViewModel: BaseViewModel {
    @Injected(key: .Backend.remanga.key) private var remangaApi: ApiProtocol
    @Injected(key: .Backend.newmanga.key) private var newmangaApi: ApiProtocol

    let items = BehaviorRelay<[MvvmCollectionSectionModel]>(value: [])
    let deselectItems = PublishRelay<Void>()

    required init() {
        super.init()
        title.accept("Профиль")
        Task { await reload() }
    }

    override func binding() {
        bind(in: disposeBag) {
            Observable.combineLatest(
                remangaApi.profile.distinctUntilChanged(),
                newmangaApi.profile.distinctUntilChanged()
            ).bind { [unowned self] _ in
                reload()
            }
        }
    }

    func modelSelected(_ model: MvvmViewModel) {
        guard let selectable = model as? MvvmSelectableProtocol
        else { return }

        selectable.selectAction?()
    }
}

private extension ProfileViewModel {
    func reload() {
        var sections: [MvvmCollectionSectionModel] = []

        let backendVM = ProfileActiveBackendViewModel()
        backendVM.detailsTitle.accept(Properties.shared.backendKey.title)

        backendVM.selectAction = { [unowned self] in
            if Properties.shared.backendKey == .newmanga {
                Properties.shared.backendKey = .remanga
            } else {
                Properties.shared.backendKey = .newmanga
            }
            backendVM.detailsTitle.accept(Properties.shared.backendKey.title)
            deselectItems.accept()
        }
        
        sections.append(.init(id: "Backend", style: .insetGrouped, showsSeparators: true, items: [backendVM]))

        var remangaItems: [MvvmViewModel] = []

        let reMangaProfileVM = ProfileAccountViewModel()
        reMangaProfileVM.image.accept(.local(name: "ReManga"))
        reMangaProfileVM.title.accept("Re:Manga")
        reMangaProfileVM.subtitle.accept("Самый крупный источник манги")

        remangaItems.append(reMangaProfileVM)

        let reMangaProfileAuthVM = ProfileUserAccountViewModel()
        if let profile = remangaApi.profile.value {
            reMangaProfileAuthVM.prepare(with: profile)

            let bookmarksVM = ProfileBookmarksViewModel()
            bookmarksVM.title.accept("Закладки")
//            remangaItems.append(bookmarksVM)
        } else {
            reMangaProfileAuthVM.title.accept("Залогинься плз")
        }

        reMangaProfileAuthVM.selectAction = { [unowned self] in
            guard remangaApi.profile.value == nil
            else { return navigate(to: ProfileDetailsViewModel.self, with: remangaApi, by: .show) }

            remangaApi.showAuthScreen(from: self)
            deselectItems.accept(())
        }

        remangaItems.append(reMangaProfileAuthVM)

        sections.append(.init(id: "ReManga", header: "Аккаунты", style: .insetGrouped, showsSeparators: true, items: remangaItems))

        var newMangaItems: [MvvmViewModel] = []

        let newMangaProfileVM = ProfileAccountViewModel()
        newMangaProfileVM.image.accept(.local(name: "NewManga"))
        newMangaProfileVM.title.accept("NewManga")
        newMangaProfileVM.subtitle.accept("Новый и преспективный источник манги")

        newMangaItems.append(newMangaProfileVM)

        let newMangaProfileAuthVM = ProfileUserAccountViewModel()
        newMangaItems.append(newMangaProfileAuthVM)

        if let profile = newmangaApi.profile.value {
            newMangaProfileAuthVM.prepare(with: profile)

            let bookmarksVM = ProfileBookmarksViewModel()
            bookmarksVM.title.accept("Закладки")
//            newMangaItems.append(bookmarksVM)
        } else {
            newMangaProfileAuthVM.title.accept("Залогинься плз")
        }

        newMangaProfileAuthVM.selectAction = { [unowned self] in
            guard newmangaApi.profile.value == nil
            else { return navigate(to: ProfileDetailsViewModel.self, with: newmangaApi, by: .show) }

            newmangaApi.showAuthScreen(from: self)
            deselectItems.accept(())
        }

        sections.append(.init(id: "NewManga", style: .insetGrouped, showsSeparators: true, items: newMangaItems))

        items.accept(sections)
    }
}
