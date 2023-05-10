//
//  ProfileViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 18.04.2023.
//

import MvvmFoundation
import RxBiBinding
import RxRelay

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
            remangaApi.authToken.distinctUntilChanged().bind { [unowned self] _ in
                reload()
            }
            newmangaApi.authToken.distinctUntilChanged().bind { [unowned self] _ in
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

        let reMangaProfileVM = ProfileAccountViewModel()
        reMangaProfileVM.image.accept(.local(name: "ReManga"))
        reMangaProfileVM.title.accept("Re:Manga")
        reMangaProfileVM.subtitle.accept("Читай мангу ёпта")

        let reMangaProfileAuthVM = ProfileUserAccountViewModel()
        if remangaApi.authToken.value == nil {
            reMangaProfileAuthVM.title.accept("Залогинься плз")
        }

        Task {
            let user = try await remangaApi.fetchUserInfo()
            reMangaProfileAuthVM.prepare(with: user)
        }

        reMangaProfileAuthVM.selectAction = { [unowned self] in
            guard remangaApi.authToken.value == nil
            else { return navigate(to: ProfileDetailsViewModel.self, with: remangaApi, by: .show) }

            remangaApi.showAuthScreen(from: self)
            deselectItems.accept(())
        }

        sections.append(.init(id: "ReManga", header: "Аккаунты", style: .insetGrouped, showsSeparators: true, items: [
            reMangaProfileVM,
            reMangaProfileAuthVM
        ]))

        let newMangaProfileVM = ProfileAccountViewModel()
        newMangaProfileVM.image.accept(.local(name: "NewManga"))
        newMangaProfileVM.title.accept("NewManga")
        newMangaProfileVM.subtitle.accept("Читай ещё мангу ёпта")

        let newMangaProfileAuthVM = ProfileUserAccountViewModel()
        newMangaProfileAuthVM.title.accept("Залогинься плз")

        Task {
            let user = try await newmangaApi.fetchUserInfo()
            newMangaProfileAuthVM.prepare(with: user)
        }

        newMangaProfileAuthVM.selectAction = { [unowned self] in
            guard newmangaApi.authToken.value == nil
            else { return navigate(to: ProfileDetailsViewModel.self, with: newmangaApi, by: .show) }

            newmangaApi.showAuthScreen(from: self)
            deselectItems.accept(())
        }

        sections.append(.init(id: "NewManga", style: .insetGrouped, showsSeparators: true, items: [
            newMangaProfileVM,
            newMangaProfileAuthVM
        ]))

        items.accept(sections)
    }
}
