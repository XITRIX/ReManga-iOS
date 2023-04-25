//
//  ProfileViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 18.04.2023.
//

import MvvmFoundation
import RxRelay
import RxBiBinding

class ProfileViewModel: BaseViewModel {
    @Injected(key: .Backend.remanga.key) private var remangaApi: ApiProtocol
    @Injected(key: .Backend.newmanga.key) private var newmangaApi: ApiProtocol

    let items = BehaviorRelay<[MvvmCollectionSectionModel]>(value: [])

    required init() {
        super.init()
        title.accept("Профиль")
        Task { await reload() }
    }

    override func binding() {
        bind(in: disposeBag) {
//            authToken <-> remangaApi.authToken
        }
    }

    func reload() {
        var sections: [MvvmCollectionSectionModel] = []

        let reMangaProfileVM = ProfileAccountViewModel()
        reMangaProfileVM.image.accept(nil)
        reMangaProfileVM.title.accept("Re:Manga")
        reMangaProfileVM.subtitle.accept("Читай мангу ёпта")
        
        sections.append(.init(id: "ReManga", header: "Аккаунты", style: .insetGrouped, showsSeparators: true, items: [
            reMangaProfileVM,
            ProfileUserAccountViewModel()
        ]))

        let newMangaProfileVM = ProfileAccountViewModel()
        newMangaProfileVM.image.accept(nil)
        newMangaProfileVM.title.accept("NewManga")
        newMangaProfileVM.subtitle.accept("Читай ещё мангу ёпта")

        sections.append(.init(id: "NewManga", style: .insetGrouped, showsSeparators: true, items: [
            newMangaProfileVM,
            ProfileUserAccountViewModel()
        ]))

        items.accept(sections)
    }
}
