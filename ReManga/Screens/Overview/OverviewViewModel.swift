//
//  OverviewViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 04.07.2023.
//

import MvvmFoundation
import RxSwift
import RxRelay

class OverviewViewModel: BaseViewModel {
    let sections = BehaviorRelay<[MvvmCollectionSectionModel]>(value: [])

    required init() {
        super.init()
        title.accept("Главная")
        Task { await reload() }
    }
}

private extension OverviewViewModel {
    func reload() {
        let popHeader = MangaDetailsHeaderViewModel(with: "Горячие новинки")
        let populars = WidgetHCollectionViewModel(with: ReMangaPopularWidget())
        let section = MvvmCollectionSectionModel(id: "Popular", style: .plain, showsSeparators: false, items: [popHeader, populars])
        sections.accept([section])
    }
}
